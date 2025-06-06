# https://learn.microsoft.com/en-us/powershell
using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
$masterPassword = $json.master
$name = $env:USERNAME

function userDataPopUp() {
    param(
        [string]$DataEmail,
        [string]$DataPassword,
        [string]$DataWebsite,
        [string]$DataDescription
    )
    
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
                    $global:masterPassword = $json.master
                    [System.Windows.Forms.MessageBox]::Show("Master password set successfully.", "Success", "OK", "Information")
                    $form.Close()
                    login
                }
            })
        $form.Controls.Add($saveButton)

        $form.ShowDialog()
    }
    
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Password Manager Login'
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false

    $form.Text = 'User Data'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'
    
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Email: $DataEmail "
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(250, 20)
    $form.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = 'OK'
    $okButton.Location = New-Object System.Drawing.Point(100, 130)
    $okButton.Add_Click({ $form.Close() })
    $form.Controls.Add($okButton)

    $form.ShowDialog()
}

function createObject {
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $form.Text = 'Create Object'
    $form.Size = New-Object System.Drawing.Size(300, 200)
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

    $result = $form.ShowDialog()
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

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(5, 230)
    $okButton.Size = New-Object System.Drawing.Size(120, 23)
    $okButton.Text = 'Change Masterkey'
    $okButton.Add_Click({
            changeMasterKey
        })
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    # $okButton = New-Object System.Windows.Forms.Button
    # $okButton.Location = New-Object System.Drawing.Point(5, 260)
    # $okButton.Size = New-Object System.Drawing.Size(120, 23)
    # $okButton.Text = 'Refresh'
    # $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    # $form.AcceptButton = $okButton
    # $form.Controls.Add($okButton)
   
    # password list
    $scrollPanel = New-Object System.Windows.Forms.Panel
    $scrollPanel.Location = [System.Drawing.Point]::new(140, 0)
    $scrollPanel.Size = [System.Drawing.Size]::new(550, 550)
    $scrollPanel.BackColor = [System.Drawing.Color]::LightGray
    $scrollPanel.AutoScroll = $true
    $form.Controls.Add($scrollPanel)

    $i = 0
    foreach ($entry in $json.entries) {
        $name = $entry.name
        $website = $entry.website
        $email = $entry.email
        $password = $entry.password
        $service = $entry.service

        $dataGroupBox = New-Object System.Windows.Forms.GroupBox
        $dataGroupBox.Text = $service
        $dataGroupBox.Size = [System.Drawing.Size]::new(500, 90)
        $dataGroupBox.Location = [System.Drawing.Point]::new(10, 10 + $i * 100)
        $dataGroupBox.BackColor = [System.Drawing.Color][System.Drawing.ColorTranslator]::FromHtml("#f8f9fa")

        $emailLabel = New-Object System.Windows.Forms.Label
        $emailLabel.Text = $email
        $emailLabel.Location = [System.Drawing.Point]::new(10, 60)
        $emailLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($emailLabel)

        $descriptionLabel = New-Object System.Windows.Forms.Label
        $descriptionLabel.Text = $name
        $descriptionLabel.Location = [System.Drawing.Point]::new(10, 20)
        $descriptionLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($descriptionLabel)

        $websiteLabel = New-Object System.Windows.Forms.Label
        $websiteLabel.Text = $website
        $websiteLabel.Location = [System.Drawing.Point]::new(10, 40)
        $websiteLabel.Size = [System.Drawing.Size]::new(300, 20)

        $dataGroupBox.Controls.Add($websiteLabel)

        $eventButton = New-Object System.Windows.Forms.Button
        $eventButton.Text = "Event $i"
        $eventButton.Location = [System.Drawing.Point]::new(0, 0)
        $eventButton.Size = [System.Drawing.Size]::new(500, 90)
        $eventButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#f8f9fa")
        $eventButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $eventButton.ForeColor = [System.Drawing.Color]::White
        $eventButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
        $eventButton.Add_Click({
                userDataPopUp $entry.email $password $website $name
            })
        $dataGroupBox.Controls.Add($eventButton)

        $scrollPanel.Controls.Add($dataGroupBox)
        $i++
    }

    # ui style 
    $sidebarBackground = New-Object System.Windows.Forms.Panel
    $sidebarBackground.Size = [System.Drawing.Size]::new(5, 550)
    $sidebarBackground.Location = [System.Drawing.Point]::new(135, 0)
    $sidebarBackground.BackColor = [System.Drawing.Color]::Black

    $topbarBackground = New-Object System.Windows.Forms.Panel
    $topbarBackground.Size = [System.Drawing.Size]::new(730, 30)
    $topbarBackground.Location = [System.Drawing.Point]::new(0, 0)
    $topbarBackground.BackColor = [System.Drawing.Color]::Red

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Password Manager"
    $label.Location = New-Object System.Drawing.Point(13, 110)
    $label.Size = New-Object System.Drawing.Size(110, 20)
    #$label.BackColor = 
    $form.Controls.Add($label)

    # $form.Controls.Add($topbarBackground)
    $form.Controls.Add($sidebarBackground)
    
    $result = $form.ShowDialog()
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
    $result = $form.ShowDialog()

}

if ($json -and $json.master -ne $null) {
    if ($json.master -eq "") {
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
                    $global:masterPassword = $json.master
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
