#Requires -version 5.0

Add-Type -AssemblyName PresentationFramework

$form = New-Object System.Windows.Window
#define what it looks like
$form.Title = "Services Demo"
$form.Height = 400
$form.Width = 500

$stack = New-object System.Windows.Controls.StackPanel

#create a label
$label = New-Object System.Windows.Controls.Label
$label.HorizontalAlignment = "Left"
$label.Content = "Enter a Computer name:"
#add to the stack
$stack.AddChild($label)

#create a text box
$TextBox = New-Object System.Windows.Controls.TextBox
$TextBox.Width = 110
$TextBox.HorizontalAlignment = "Left"
$TextBox.Text = $env:COMPUTERNAME

#add to the stack
$stack.AddChild($TextBox)

#create a datagrid
$datagrid = New-Object System.Windows.Controls.DataGrid
$datagrid.HorizontalAlignment = "Center"
$datagrid.VerticalAlignment = "Bottom"
$datagrid.Height = 250
$datagrid.Width = 441

$datagrid.CanUserResizeColumns = "True"

$stack.AddChild($datagrid)

#create a button
$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_OK"
$btn.Width = 75
$btn.HorizontalAlignment = "Center"

#this will now work
$OK = {
    Write-Host "Getting services from $($textbox.Text)" -ForegroundColor Green;
    $data = Get-Service  | Select-Object Name,Status,Displayname
    $datagrid.ItemsSource = $data
}
#add an event handler
$btn.Add_click($OK)

#add to the stack
$stack.AddChild($btn)

#add the stack to the form
$form.AddChild($stack)

#run the OK scriptblock when form is loaded
$form.Add_Loaded($OK)

$btnQuit = new-object System.Windows.Controls.Button
$btnQuit.Content = "_Quit"
$btnQuit.Width = 75
$btnQuit.HorizontalAlignment = "center"

#add the quit button to the stack
$stack.AddChild($btnQuit)

#close the form
$btnQuit.add_click({$form.Close()})

#show the form and suppress the boolean output
$form.ShowDialog() | Out-Null


