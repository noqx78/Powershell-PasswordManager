# https://learn.microsoft.com/en-us/powershell
using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
$masterPassword = $json.master
$name = $env:USERNAME

function userDataPopUp {
    param(
        [string]$DataEmail,
        [string]$DataPassword, 
        [string]$DataWebsite,
        [string]$DataService
    )
    
    
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Password Details'
    $form.Size = New-Object System.Drawing.Size(400, 280)
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false
    
    # Service/Name Label
    $serviceLabel = New-Object System.Windows.Forms.Label
    $serviceLabel.Text = "Service:"
    $serviceLabel.Location = New-Object System.Drawing.Point(20, 20)
    $serviceLabel.Size = New-Object System.Drawing.Size(60, 20)
    $serviceLabel.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($serviceLabel)
    
    $serviceValue = New-Object System.Windows.Forms.Label
    $serviceValue.Text = $DataService
    $serviceValue.Location = New-Object System.Drawing.Point(90, 20)
    $serviceValue.Size = New-Object System.Drawing.Size(280, 20)
    $form.Controls.Add($serviceValue)
    
    # Email Label
    $emailLabel = New-Object System.Windows.Forms.Label
    $emailLabel.Text = "Email:"
    $emailLabel.Location = New-Object System.Drawing.Point(20, 50)
    $emailLabel.Size = New-Object System.Drawing.Size(60, 20)
    $emailLabel.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($emailLabel)
    
    $emailValue = New-Object System.Windows.Forms.TextBox
    $emailValue.Text = $DataEmail
    $emailValue.Location = New-Object System.Drawing.Point(90, 50)
    $emailValue.Size = New-Object System.Drawing.Size(200, 20)
    $emailValue.ReadOnly = $true
    $form.Controls.Add($emailValue)
    
    # Copy Email Button
    $copyEmailBtn = New-Object System.Windows.Forms.Button
    $copyEmailBtn.Text = 'Copy'
    $copyEmailBtn.Location = New-Object System.Drawing.Point(300, 48)
    $copyEmailBtn.Size = New-Object System.Drawing.Size(50, 25)
    $copyEmailBtn.Add_Click({
            [System.Windows.Forms.Clipboard]::SetText($DataEmail)
            [System.Windows.Forms.MessageBox]::Show("Email copied to clipboard!", "Copied", "OK", "Information")
        })
    $form.Controls.Add($copyEmailBtn)
    
    # Password Label
    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Text = "Password:"
    $passwordLabel.Location = New-Object System.Drawing.Point(20, 80)
    $passwordLabel.Size = New-Object System.Drawing.Size(60, 20)
    $passwordLabel.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($passwordLabel)
    
    $passwordValue = New-Object System.Windows.Forms.TextBox
    $passwordValue.Text = $DataPassword
    $passwordValue.Location = New-Object System.Drawing.Point(90, 80)
    $passwordValue.Size = New-Object System.Drawing.Size(200, 20)
    $passwordValue.UseSystemPasswordChar = $true
    $passwordValue.ReadOnly = $true
    $form.Controls.Add($passwordValue)
    
    # Copy Password Button
    $copyPasswordBtn = New-Object System.Windows.Forms.Button
    $copyPasswordBtn.Text = 'Copy'
    $copyPasswordBtn.Location = New-Object System.Drawing.Point(300, 78)
    $copyPasswordBtn.Size = New-Object System.Drawing.Size(50, 25)
    $copyPasswordBtn.Add_Click({
            [System.Windows.Forms.Clipboard]::SetText($DataPassword)
            [System.Windows.Forms.MessageBox]::Show("Password copied to clipboard!", "Copied", "OK", "Information")
        })
    $form.Controls.Add($copyPasswordBtn)
    
    # Show/Hide Password Button
    $showPasswordBtn = New-Object System.Windows.Forms.Button
    $showPasswordBtn.Text = 'Show'
    $showPasswordBtn.Location = New-Object System.Drawing.Point(90, 108)
    $showPasswordBtn.Size = New-Object System.Drawing.Size(60, 25)
    $showPasswordBtn.Add_Click({
            if ($passwordValue.UseSystemPasswordChar) {
                $passwordValue.UseSystemPasswordChar = $false
                $showPasswordBtn.Text = 'Hide'
            }
            else {
                $passwordValue.UseSystemPasswordChar = $true
                $showPasswordBtn.Text = 'Show'
            }
        })
    $form.Controls.Add($showPasswordBtn)
    
    # Website Label
    $websiteLabel = New-Object System.Windows.Forms.Label
    $websiteLabel.Text = "Website:"
    $websiteLabel.Location = New-Object System.Drawing.Point(20, 140)
    $websiteLabel.Size = New-Object System.Drawing.Size(60, 20)
    $websiteLabel.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($websiteLabel)
    
    $websiteValue = New-Object System.Windows.Forms.TextBox
    $websiteValue.Text = $DataWebsite
    $websiteValue.Location = New-Object System.Drawing.Point(90, 140)
    $websiteValue.Size = New-Object System.Drawing.Size(200, 20)
    $websiteValue.ReadOnly = $true
    $form.Controls.Add($websiteValue)
    
    # Open Website Button
    $openWebsiteBtn = New-Object System.Windows.Forms.Button
    $openWebsiteBtn.Text = 'Open'
    $openWebsiteBtn.Location = New-Object System.Drawing.Point(300, 138)
    $openWebsiteBtn.Size = New-Object System.Drawing.Size(50, 25)
    $openWebsiteBtn.Add_Click({
            if ($DataWebsite -and $DataWebsite -ne "") {
                Start-Process $DataWebsite
            }
        })

   
    $form.Controls.Add($openWebsiteBtn)

    $deleteButton = New-Object System.Windows.Forms.Button
    $deleteButton.Text = 'Delete'
    $deleteButton.Location = New-Object System.Drawing.Point(260, 180)
    $deleteButton.Size = New-Object System.Drawing.Size(75, 30)
    $deleteButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#dc3545")
    $deleteButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $deleteButton.ForeColor = [System.Drawing.Color]::White
    $deleteButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $deleteButton.Add_Click({ 
            $result = [System.Windows.Forms.MessageBox]::Show(
                "Are you sure?", 
                "Confirm", 
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
        
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                $global:json.entries = @($global:json.entries | Where-Object { 
                        $_.service -ne $DataService 
                    })
                $global:json | ConvertTo-Json -Depth 10 | Set-Content -Path "data.json"
                [System.Windows.Forms.MessageBox]::Show("Entry deleted", "Success", "OK", "Information")
                $form.Close()
                passwordManager
            }
        })
    $form.Controls.Add($deleteButton)

    # Close Button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = 'Close'
    $okButton.Location = New-Object System.Drawing.Point(160, 180)
    $okButton.Size = New-Object System.Drawing.Size(75, 30)
    $okButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#017bfe")
    $okButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $okButton.ForeColor = [System.Drawing.Color]::White
    $okButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $okButton.Add_Click({ $form.Close() })
    $form.Controls.Add($okButton)

    $form.ShowDialog()
}

function changeMasterKey() {
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Master Password'
    $form.Size = New-Object System.Drawing.Size(350, 180)
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "New Master Password"
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.Size = New-Object System.Drawing.Size(300, 20)
    $form.Controls.Add($label)
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(20, 50)
    $textBox.Size = New-Object System.Drawing.Size(300, 20)
    $textBox.UseSystemPasswordChar = $true
    $form.Controls.Add($textBox)
    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = 'Save'
    $saveButton.Location = New-Object System.Drawing.Point(120, 90)
    $saveButton.Size = New-Object System.Drawing.Size(100, 30)
    $saveButton.Add_Click({
            if ($textBox.Text -eq "") {
                [System.Windows.Forms.MessageBox]::Show("Password cannot be empty.", "Error", "OK", "Warning")
            }
            else {
                $json.master = $textBox.Text
                $json | ConvertTo-Json | Set-Content -Path "data.json"
                $global:json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
                [System.Windows.Forms.MessageBox]::Show("Master password set successfully.", "Success", "OK", "Information")
                $form.Close()
            }
        })
    $form.Controls.Add($saveButton)
    $form.ShowDialog()
}

function createObject {
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $form.Text = 'Create Object'
    $form.Size = New-Object System.Drawing.Size(400, 300)
    $form.StartPosition = 'CenterScreen'

    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = "Name:"
    $nameLabel.Location = New-Object System.Drawing.Point(20, 20)
    $nameLabel.Size = New-Object System.Drawing.Size(70, 20)
    $form.Controls.Add($nameLabel)

    $emailLabel = New-Object System.Windows.Forms.Label
    $emailLabel.Text = "Email:"
    $emailLabel.Location = New-Object System.Drawing.Point(20, 50)
    $emailLabel.Size = New-Object System.Drawing.Size(70, 20)
    $form.Controls.Add($emailLabel)

    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Text = "Password:"
    $passwordLabel.Location = New-Object System.Drawing.Point(20, 80)
    $passwordLabel.Size = New-Object System.Drawing.Size(70, 20)
    $form.Controls.Add($passwordLabel)

    $websiteLabel = New-Object System.Windows.Forms.Label
    $websiteLabel.Text = "Website:"
    $websiteLabel.Location = New-Object System.Drawing.Point(20, 110)
    $websiteLabel.Size = New-Object System.Drawing.Size(70, 20)
    $form.Controls.Add($websiteLabel)

    $nameTextBox = New-Object System.Windows.Forms.TextBox
    $nameTextBox.Location = New-Object System.Drawing.Point(100, 20)
    $nameTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $form.Controls.Add($nameTextBox)

    $emailTextBox = New-Object System.Windows.Forms.TextBox
    $emailTextBox.Location = New-Object System.Drawing.Point(100, 50)
    $emailTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $form.Controls.Add($emailTextBox)

    $passwordTextBox = New-Object System.Windows.Forms.TextBox
    $passwordTextBox.Location = New-Object System.Drawing.Point(100, 80)
    $passwordTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $passwordTextBox.UseSystemPasswordChar = $true
    $form.Controls.Add($passwordTextBox)

    $websiteTextBox = New-Object System.Windows.Forms.TextBox
    $websiteTextBox.Location = New-Object System.Drawing.Point(100, 110)
    $websiteTextBox.Size = New-Object System.Drawing.Size(170, 20)
    $form.Controls.Add($websiteTextBox)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Location = New-Object System.Drawing.Point(100, 140)
    $saveButton.Size = New-Object System.Drawing.Size(75, 23)
    $saveButton.Text = 'Save'
    $saveButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#017bfe")
    $saveButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $saveButton.ForeColor = [System.Drawing.Color]::White
    $saveButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $saveButton.Add_Click({
            $newEntry = @{
                "service"  = $nameTextBox.Text
                "email"    = $emailTextBox.Text
                "password" = $passwordTextBox.Text
                "website"  = $websiteTextBox.Text
            }
        
            # Add new entry to json
            $json.entries += $newEntry
            $jsonContent = $json | ConvertTo-Json
            Set-Content -Path "data.json" -Value $jsonContent

            [System.Windows.Forms.MessageBox]::Show("Entry saved successfully!", "Success", "OK", "Information")
            $form.Close()
        })
    $form.Controls.Add($saveButton)

    # Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(195, 140)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.Add_Click({ $form.Close() })
    $form.Controls.Add($cancelButton)

    $form.ShowDialog()
}

function passwordManager() {
    $form = New-Object System.Windows.Forms.Form
    
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Password Manager'
    $form.Size = New-Object System.Drawing.Size(730, 550)
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false

    $iconPath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.ico"
    $form.Icon = New-Object System.Drawing.Icon($iconPath)

    $imagePath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.png"
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Point(5, 10)
    $pictureBox.Size = New-Object System.Drawing.Size(100, 100)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
    $pictureBox.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($pictureBox)

    # buttons 
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(5, 200)
    $okButton.Size = New-Object System.Drawing.Size(120, 23)
    $okButton.Text = 'Create Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#017bfe")
    $okButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $okButton.ForeColor = [System.Drawing.Color]::White
    $okButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $okButton.Add_Click({
            createObject
        })
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    # system user name 
    $systemNameLabel = New-Object System.Windows.Forms.Label
    $systemNameLabel.Text = $name
    $systemNameLabel.Location = [System.Drawing.Point]::new(5, 440)
    $systemNameLabel.Size = [System.Drawing.Size]::new(100, 20)
    $form.Controls.Add($systemNameLabel)

    $logoutButton = New-Object System.Windows.Forms.Button
    $logoutButton.Location = New-Object System.Drawing.Point(5, 470)
    $logoutButton.Size = New-Object System.Drawing.Size(120, 30)
    $logoutButton.Text = 'Logout'
    $logoutButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $logoutButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#dc3545")
    $logoutButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $logoutButton.ForeColor = [System.Drawing.Color]::White
    $logoutButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    
    $form.AcceptButton = $logoutButton
    $logoutButton.Add_Click({
            $form.Close()
        })
    $form.Controls.Add($logoutButton)

    $changeMasterKeyButton = New-Object System.Windows.Forms.Button
    $changeMasterKeyButton.Location = New-Object System.Drawing.Point(5, 230)
    $changeMasterKeyButton.Size = New-Object System.Drawing.Size(120, 23)
    $changeMasterKeyButton.Text = 'Change Masterkey'
    $changeMasterKeyButton.Add_Click({
            changeMasterKey
        })
    $form.AcceptButton = $changeMasterKeyButton
    $form.Controls.Add($changeMasterKeyButton)
   
    # password list
    $scrollPanel = New-Object System.Windows.Forms.Panel
    $scrollPanel.Location = [System.Drawing.Point]::new(140, 0)
    $scrollPanel.Size = [System.Drawing.Size]::new(550, 550)
    $scrollPanel.BackColor = [System.Drawing.Color]::LightGray
    $scrollPanel.AutoScroll = $true
    $form.Controls.Add($scrollPanel)

    $i = 0
    foreach ($entry in $json.entries) {
        $currentEntry = $entry  
        
        $dataGroupBox = New-Object System.Windows.Forms.GroupBox
        $dataGroupBox.Text = $currentEntry.service
        $dataGroupBox.Size = [System.Drawing.Size]::new(500, 90)
        $dataGroupBox.Location = [System.Drawing.Point]::new(10, 10 + $i * 100)
        $dataGroupBox.BackColor = [System.Drawing.Color][System.Drawing.ColorTranslator]::FromHtml("#f8f9fa")

        $emailLabel = New-Object System.Windows.Forms.Label
        $emailLabel.Text = $currentEntry.email
        $emailLabel.Location = [System.Drawing.Point]::new(10, 60)
        $emailLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($emailLabel)

        $descriptionLabel = New-Object System.Windows.Forms.Label
        $descriptionLabel.Text = $currentEntry.name
        $descriptionLabel.Location = [System.Drawing.Point]::new(10, 20)
        $descriptionLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($descriptionLabel)

        $websiteLabel = New-Object System.Windows.Forms.Label
        $websiteLabel.Text = $currentEntry.website
        $websiteLabel.Location = [System.Drawing.Point]::new(10, 40)
        $websiteLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($websiteLabel)

        $eventButton = New-Object System.Windows.Forms.Button
        $eventButton.Text = ""
        $eventButton.Location = [System.Drawing.Point]::new(0, 0)
        $eventButton.Size = [System.Drawing.Size]::new(500, 90)
        $eventButton.BackColor = [System.Drawing.Color]::Transparent
        $eventButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $eventButton.FlatAppearance.BorderSize = 0
        $eventButton.FlatAppearance.MouseOverBackColor = [System.Drawing.ColorTranslator]::FromHtml("#e9ecef")
        $eventButton.Add_Click({
                userDataPopUp -DataEmail $currentEntry.email -DataPassword $currentEntry.password -DataWebsite $currentEntry.website -DataService $currentEntry.service
            }.GetNewClosure())
        
        $dataGroupBox.Controls.Add($eventButton)
        $scrollPanel.Controls.Add($dataGroupBox)
        $i++
    }

    # ui style 
    $sidebarBackground = New-Object System.Windows.Forms.Panel
    $sidebarBackground.Size = [System.Drawing.Size]::new(5, 550)
    $sidebarBackground.Location = [System.Drawing.Point]::new(135, 0)
    $sidebarBackground.BackColor = [System.Drawing.Color]::Black

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Password Manager"
    $label.Location = New-Object System.Drawing.Point(13, 110)
    $label.Size = New-Object System.Drawing.Size(110, 20)
    $form.Controls.Add($label)

    $form.Controls.Add($sidebarBackground)
    
    $form.ShowDialog()
}

function login() {
    # window
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Password Manager Login'
    $form.Size = New-Object System.Drawing.Size(680, 400)
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false

    # window icons
    $iconPath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.ico"
    $form.Icon = New-Object System.Drawing.Icon($iconPath)

    # login image
    $imagePath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_lock.png"
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Point(20, 20)
    $pictureBox.Size = New-Object System.Drawing.Size(250, 250)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
    $form.Controls.Add($pictureBox)

    # button
    $loginButton = New-Object System.Windows.Forms.Button
    $loginButton.Location = New-Object System.Drawing.Point(425, 170)
    $loginButton.Size = New-Object System.Drawing.Size(75, 23)
    $loginButton.Text = 'Login'
    $loginButton.Add_Click({
            if ($textBox.Text -eq $masterPassword) {
                $form.Close() 
                passwordManager
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("false password", "Error", "ok", "Warning")
            }
        })
    $form.Controls.Add($loginButton)

    # text
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(410, 120)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Masterkey Password'
    $form.Controls.Add($label)

    # textbox input for masterkey
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(350, 140)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $form.Controls.Add($textBox)

    $form.Add_Shown({ $textBox.Select() })
    $form.ShowDialog()
}

if ($null -ne $json -and $null -ne $json.master) {
    if ("" -eq $json.master) {
        $form = New-Object System.Windows.Forms.Form
        $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $form.Text = 'Master Password'
        $form.Size = New-Object System.Drawing.Size(350, 180)
        $form.StartPosition = 'CenterScreen'
        $form.MaximizeBox = $false

        $label = New-Object System.Windows.Forms.Label
        $label.Text = "New Master Password"
        $label.Location = New-Object System.Drawing.Point(20, 20)
        $label.Size = New-Object System.Drawing.Size(300, 20)
        $form.Controls.Add($label)

        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Location = New-Object System.Drawing.Point(20, 50)
        $textBox.Size = New-Object System.Drawing.Size(300, 20)
        $textBox.UseSystemPasswordChar = $true
        $form.Controls.Add($textBox)

        $saveButton = New-Object System.Windows.Forms.Button
        $saveButton.Text = 'Save'
        $saveButton.Location = New-Object System.Drawing.Point(120, 90)
        $saveButton.Size = New-Object System.Drawing.Size(100, 30)
        $saveButton.Add_Click({
                if ($textBox.Text -eq "") {
                    [System.Windows.Forms.MessageBox]::Show("Password cannot be empty.", "Error", "OK", "Warning")
                }
                else {
                    $json.master = $textBox.Text
                    $json | ConvertTo-Json | Set-Content -Path "data.json"
                    $global:json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
                    [System.Windows.Forms.MessageBox]::Show("Master password set successfully.", "Success", "OK", "Information")
                    $form.Close()
                    login
                }
            })
        $form.Controls.Add($saveButton)

        $form.ShowDialog()
    }
    else {
        login
    }
}
else {
    [System.Windows.Forms.MessageBox]::Show("Error loading data.", "Error", "OK", "Warning")
}