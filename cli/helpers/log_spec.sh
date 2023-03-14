Describe 'cli/helpers/log.sh'

    Include cli/helpers/log.sh

    setup() {
        TEST_ANSI_RED='\033[1;31m'
        TEST_ANSI_YELLOW='\033[1;33m'
        TEST_ANSI_GREEN='\033[1;32m'
        TEST_ANSI_CYAN='\033[1;36m'
        TEST_ANSI_GREY='\033[0;37m'
        TEST_ANSI_CLEAR='\033[0m'
    }

    clean_up() {
        unset TEST_ANSI_RED
        unset TEST_ANSI_YELLOW
        unset TEST_ANSI_GREEN
        unset TEST_ANSI_CYAN
        unset TEST_ANSI_GREY
        unset TEST_ANSI_CLEAR
    }

    BeforeEach 'setup'

    AfterEach 'clean_up'

    Describe 'log_step()'
        It "sends a message prefixed with 'STEP:'"
            expected_output=$(
                %printf \
                    "${TEST_ANSI_GREY}%s${TEST_ANSI_CLEAR}" \
                    "STEP: look here"
            )
            When call log_step 'look here'
            The output should equal "${expected_output}"
        End
    End

    Describe 'log_start()'
        It "sends a message prefixed with 'START:'"
            expected_output=$(
                %printf \
                    "${TEST_ANSI_CYAN}\n%s${TEST_ANSI_CLEAR}" \
                    "START: look here"
            )
            When call log_start 'look here'
            The output should equal "${expected_output}"
        End
    End

    Describe 'log_finish()'
        It "sends a message prefixed with 'FINISH:'"
            expected_output=$(
                %printf \
                    "${TEST_ANSI_CYAN}%s\n${TEST_ANSI_CLEAR}" \
                    "FINISH: look here"
            )
            When call log_finish 'look here'
            The output should equal "${expected_output}"
        End
    End


    Describe 'log_info()'
        It "sends a message prefixed with 'INFO:'"
            expected_output=$(
                %printf "${TEST_ANSI_GREEN}INFO: look here${TEST_ANSI_CLEAR}"
            )
            When call log_info 'look here'
            The output should equal "${expected_output}"
        End
    End

    Describe 'log_warn()'
        It "sends a message prefixed with 'WARN:'"
            expected_output=$(
                %printf "${TEST_ANSI_YELLOW}WARN: look here${TEST_ANSI_CLEAR}"
            )
            When call log_warn 'look here'
            The output should equal "${expected_output}"
        End
    End

    Describe 'log_error()'
        It "sends a message prefixed with 'ERROR:'"
            expected_output="$(
                echo -e "${TEST_ANSI_RED}"
                %text
                #|
                #|ERROR: look here
                echo -e "${TEST_ANSI_CLEAR}"
            )"
            When call log_error 'look here'
            The output should equal "${expected_output}"
        End
    End
End
