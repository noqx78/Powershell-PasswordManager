# https://learn.microsoft.com/en-us/powershell
using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
$masterPassword = $json.master
$name = $env:USERNAME


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
    $pictureBox.Location = New-Object System.Drawing.Point(0, 10)
    $pictureBox.Size = New-Object System.Drawing.Size(100, 100)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
    $pictureBox.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($pictureBox)

    # buttons 
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(12, 200)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Create Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(12, 230)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Change Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(12, 260)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Delete Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $logoutButton = New-Object System.Windows.Forms.Button
    $logoutButton.Location = New-Object System.Drawing.Point(12, 370)
    $logoutButton.Size = New-Object System.Drawing.Size(95, 23)
    $logoutButton.Text = 'Logout'
    $logoutButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $logoutButton
    $logoutButton.Add_Click({
            $form.Close()
        })
    $form.Controls.Add($logoutButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(5, 340)
    $okButton.Size = New-Object System.Drawing.Size(110, 23)
    $okButton.Text = 'Change Masterkey'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
   
    # password list
    $scrollPanel = New-Object System.Windows.Forms.Panel
    $scrollPanel.Location = [System.Drawing.Point]::new(120, 0)
    $scrollPanel.Size = [System.Drawing.Size]::new(350, 550)
    $scrollPanel.BackColor = [System.Drawing.Color]::LightGray
    $scrollPanel.AutoScroll = $true
    $form.Controls.Add($scrollPanel)

    for ($i = 0; $i -lt 20; $i++) {

        $description = $entry.$description
        $website = $entry.$website
        $email = $entry.$email
        $password = $entry.$password


        $dataGroupBox = New-Object System.Windows.Forms.GroupBox
        $dataGroupBox.Text = $service
        $dataGroupBox.Size = [System.Drawing.Size]::new(330, 70)
        $dataGroupBox.Location = [System.Drawing.Point]::new(10, 10 + $i * 80)
        $dataGroupBox.BackColor = [System.Drawing.Color]::WhiteSmoke

        $emailLabel = New-Object System.Windows.Forms.Label
        $emailLabel.Text = $email
        $emailLabel.Location = [System.Drawing.Point]::new(10, 25)
        $emailLabel.Size = [System.Drawing.Size]::new(300, 20)
        $dataGroupBox.Controls.Add($emailLabel)

        $eventButton = New-Object System.Windows.Forms.Button
        $eventButton.Text = "Event $i"
        $eventButton.Location = [System.Drawing.Point]::new(10, 10 + $i * 80)
        $eventButton.Size = [System.Drawing.Size]::new(75, 23)
        $eventButton.Add_Click({
                [System.Windows.Forms.MessageBox]::Show("Event $i clicked for $service", "Event Triggered", "OK", "Information")
            })

        $scrollPanel.Controls.Add($eventButton)
        $scrollPanel.Controls.Add($dataGroupBox)
    }

    # ui style 
    $sidebarBackground = New-Object System.Windows.Forms.Panel
    $sidebarBackground.Size = [System.Drawing.Size]::new(120, 550)
    $sidebarBackground.Location = [System.Drawing.Point]::new(0, 0)
    $sidebarBackground.BackColor = [System.Drawing.Color]::Gray

    $topbarBackground = New-Object System.Windows.Forms.Panel
    $topbarBackground.Size = [System.Drawing.Size]::new(730, 30)
    $topbarBackground.Location = [System.Drawing.Point]::new(0, 0)
    $topbarBackground.BackColor = [System.Drawing.Color]::Red

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Password Manager"
    $label.Location = New-Object System.Drawing.Point(5, 120)
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
                if ($masterPassword -eq "") {
                    [System.Windows.Forms.MessageBox]::Show("please set a MasterPassword", "Error", "ok", "Warning")
                }
                else {
                    $form.Close() 
                    passwordManager
                }
            }
            elseif ($textBox.Text = "") {
                [System.Windows.Forms.MessageBox]::Show("please set a MasterPassword", "Error", "ok", "Warning")
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

#login
passwordManager
