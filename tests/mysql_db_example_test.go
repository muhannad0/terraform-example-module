package test

import (
	"fmt"
	"testing"
	"strings"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
)

func TestMySqlDbExample(t *testing.T) {
	t.Parallel()

	uniqueId := strings.ToLower(random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/mysql-db",
		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("test%s", uniqueId),
			"db_name": fmt.Sprintf("db%s", uniqueId),
			"db_user": "admin",
			"db_pass": "testpassword123",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}