# https://learn.microsoft.com/en-us/powershell
using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$json = Get-Content -Path "data.json" -Raw | ConvertFrom-Json
$masterPassword = "test"

function passwordManager() {
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.Text = 'Password Manager'
    $form.Size = New-Object System.Drawing.Size(750, 650)
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false

    $iconPath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.ico"
    $form.Icon = New-Object System.Drawing.Icon($iconPath)

    $imagePath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.png"
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Point(20, 10)
    $pictureBox.Size = New-Object System.Drawing.Size(150, 150)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
    $form.Controls.Add($pictureBox)

    # buttons 
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(225, 40)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Create Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(320, 40)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Change Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(415, 40)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Delete Object'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(550, 40)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Logout'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(550, 65)
    $okButton.Size = New-Object System.Drawing.Size(95, 23)
    $okButton.Text = 'Change Masterkey'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
   
    # password list
    $dataGridView = New-Object System.Windows.Forms.DataGridView
    $dataGridView.Location = New-Object System.Drawing.Point(20, 190)
    $dataGridView.Size = New-Object System.Drawing.Size(720, 450)
    $dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
    $dataGridView.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize
    $dataGridView.AllowUserToAddRows = $true
    $dataGridView.AllowUserToDeleteRows = $true

    $dataGridView.Columns.Add("Title", "Title")
    $dataGridView.Columns.Add("Username", "Username")
    $dataGridView.Columns.Add("Password", "Password")
    $dataGridView.Columns.Add("URL", "URL")
    $dataGridView.Columns.Add("Notes", "Notes")

    $dataGridView.Rows.Add("Example", "user@example.com", "password123", "https://example.com", "Sample entry")

    $form.Controls.Add($dataGridView)
    
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

    # Set the form icon
    $iconPath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_logo.ico"
    $form.Icon = New-Object System.Drawing.Icon($iconPath)

    $imagePath = Join-Path -Path $PSScriptRoot -ChildPath "img\ps_lock.png"
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Point(20, 20)
    $pictureBox.Size = New-Object System.Drawing.Size(250, 250)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
    $form.Controls.Add($pictureBox)

    # button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(425, 170)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'Login'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    # text
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(410, 120)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Masterkey Password'
    $form.Controls.Add($label)

    # textbox input
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(350, 140)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $form.Controls.Add($textBox)

   

    $form.Add_Shown({ $textBox.Select() })
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        if ($textBox.Text -eq $masterPassword) {
            passwordManager
        }
        else {
            Write-Host "False"
        }
    } 
}

login
passwordManager