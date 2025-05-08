***Settings***
Library    SeleniumLibrary

***Variables***
${BROWSER}              chrome   # デフォルトブラウザ。your_test.robot や robot.py から上書き可能
${SELENIUM_TIMEOUT}     15s      # 要素待機などのデフォルトタイムアウト
${LOGIN_TIMEOUT}        20s      # ログイン処理専用のタイムアウト

***Keywords***
Open Browser For Current Test
    [Arguments]    ${browser_from_csv}=${EMPTY}
    ${browser_to_actually_use}=    Set Variable If    '${browser_from_csv}' == '${EMPTY}'    ${BROWSER}    ${browser_from_csv}
    Log To Console    Attempting to open browser: ${browser_to_actually_use} (CSV specified: '${browser_from_csv}', Default: '${BROWSER}')
    Open Browser    about:blank    browser=${browser_to_actually_use}
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Maximize Browser Window
    Log To Console    Browser opened: ${browser_to_actually_use}

Close All Browsers
    Close All Browsers
    Log To Console    All browsers closed.

Login To Site
    [Arguments]    ${username}    ${password}    ${username_locator}    ${password_locator}    ${login_button_locator}    ${success_element_locator}=${EMPTY}
    Log To Console    Attempting to login user: ${username}
    Wait Until Page Contains Element    ${username_locator}    timeout=${LOGIN_TIMEOUT}
    Input Text    ${username_locator}    ${username}
    Input Password    ${password_locator}    ${password}
    Click Element    ${login_button_locator}

    IF    '${success_element_locator}' != '${EMPTY}'
        Wait Until Page Contains Element    ${success_element_locator}    timeout=${LOGIN_TIMEOUT}
        Log    Login successful. Found success element: ${success_element_locator}
    ELSE
        Log    Login attempt made. No specific success element to verify, relying on subsequent checks.
    END