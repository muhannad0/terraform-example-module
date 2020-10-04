package test

import (
	"fmt"
	"strings"
	"time"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/test-structure"
)

const webAppExampleDir = "../examples/web-app"

func createWebAppOpts(t *testing.T, appDir string) *terraform.Options {
	uniqueId := strings.ToLower(random.UniqueId())

	return &terraform.Options{
		TerraformDir: appDir,
		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("test%s", uniqueId),
			"instance_type": "t2.micro",
			"min_size": 1,
			"max_size": 1,
			"desired_capacity": 1,
			"server_text": "Hello World Testing",
		},
	}
}

func teardownApp(t *testing.T, appDir string) {
	appOpts := test_structure.LoadTerraformOptions(t, appDir)
	defer terraform.Destroy(t, appOpts)
}

func deployApp(t *testing.T, appDir string) {
	appOpts := createWebAppOpts(t, appDir)
	test_structure.SaveTerraformOptions(t, appDir, appOpts)
	terraform.InitAndApply(t, appOpts)
}

func validateApp(t *testing.T, appDir string) {
	appOpts := test_structure.LoadTerraformOptions(t, appDir)

	webAppDns := terraform.OutputRequired(t, appOpts, "web_app_dns")

	url := fmt.Sprintf("http://%s", webAppDns)
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello World Testing")
		},
	)
}

func redeployApp(t *testing.T, appDir string) {
	appOpts := test_structure.LoadTerraformOptions(t, appDir)

	webAppDns := terraform.OutputRequired(t, appOpts, "web_app_dns")
	url := fmt.Sprintf("http://%s", webAppDns)

	// start checking every 1s to make sure the app is responding with 200 OK
	stopChecking := make(chan bool, 1)
	waitGroup, _ := http_helper.ContinuouslyCheckUrl(
		t,
		url,
		stopChecking,
		1*time.Second,
	)

	// update the server text and redeploy
	newServerText := "Hello World v2"
	appOpts.Vars["server_text"] = newServerText
	terraform.Apply(t, appOpts)

	// check if new version has deployed
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, newServerText)
		},
	)

	// stop checking
	stopChecking <- true
	waitGroup.Wait()
}

func TestWebAppExample(t *testing.T) {
	t.Parallel()

	// deploy the Web App
	defer test_structure.RunTestStage(t, "teardown_app", func() { teardownApp(t, webAppExampleDir) })
	test_structure.RunTestStage(t, "deploy_app", func() { deployApp(t, webAppExampleDir) })

	// validate the Web App
	test_structure.RunTestStage(t, "validate_app", func() { validateApp(t, webAppExampleDir) })

	// redeploy and validate the Web App
	test_structure.RunTestStage(t, "redploy_app", func() { redeployApp(t, webAppExampleDir) })

	// scale the Web App and verify
	// test_structure.RunTestStage(t, "scale_app", func() { scaleApp(t, webAppExampleDir) })
}
