if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
$text = @"
             *     ,MMM8&&&.            *
                  MMMM88&&&&&    .
                 MMMM88&&&&&&&
     *           MMM88&&&&&&&&
                 MMM88&&&&&&&&
                 'MMM88&&&&&&'
                   'MMM8&&&'      *
          |\___/|
          )     (             .              '
         =\     /=
           )===(       *
          /     \         �����...)
          |     |
         /       \
         \       /
  _/\_/\_/\__  _/_/\_/\_/\_/\_/\_/\_/\_/\_/\_
  |  |  |  |( (  |  |  |  |  |  |  |  |  |  |
  |  |  |  | ) ) |  |  |  |  |  |  |  |  |  |
  |  |  |  |(_(  |  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

"@

Write-Output $text

$url = "https://www.python.org/ftp/python/3.9.2/python-3.9.2-embed-amd64.zip"
$installPath = "C:/tmp/vk-music-import"
$pythonPath = "$installPath/bin"
$installer = "$installPath/python-3.9.2-embed-amd64.zip"

Write-Host "[~] ���������, ���� ����������� ����������� (��� ����� ����� �����, ������ �� ������� � ���� �� ����������!)..."
Write-Host "[~] �������� ������������� ������������..."

if (Test-Path "$pythonPath/python.exe")
{
    Write-Host "[v] �������, Python 3.9 ��� ���������� ��������"
}
else
{
    if (Test-Path $installer)
    {
        Write-Host "[~] ��������� ���������� ������������� �����..."
    }
    else
    {
        Write-Host "[~] ��������� ������������ ��� ������� ����� ����������� � �����: $pythonPath..."
        Write-Host "[~] �������� ���������� ������������� ����� Python 3.9..."
        New-Item -ItemType Directory -Force -Path "$installPath"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $installer
        Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$installPath/get-pip.py"
    }
    Write-Host "[~] ������������ �������� Python 3.9..."
    Expand-Archive -LiteralPath $installer -DestinationPath "$pythonPath"
    Remove-Item $pythonPath/python39._pth
    & $pythonPath/python.exe $installPath/get-pip.py
    Write-Host "[v] �������, Python 3.9 ���������� � ${pythonPath}."
}

Write-Host "[~] �������� ����������� ��������� � Python..."
$freezeOutput = (& $pythonPath/Scripts/pip.exe freeze)
$dependencies = @("python-dotenv==0.20.0", "vk-api==11.9.7", "vk-captchasolver==1.0.0")
$isDepsInstalled = $true
For ($i = 0; $i -lt $dependencies.Length; $i++) {
    $dep = $dependencies[$i]
    if ($freezeOutput -NotLike "*$dep*")
    {
        $isDepsInstalled = $false
        Write-Host "[~] ��� ���������: $dep..."
    }
}

if (-Not $isDepsInstalled)
{
    Write-Host "[~] ��������� ����������� ��������� � Python..."
    & $pythonPath/Scripts/pip.exe install --user -r $PSScriptRoot/requirements.txt
}
Write-Host "[v] ���������� �����������, ��������� ������..."
#Clear-Host

$successCats = @"
            *     ,MMM8&&&.            *
                  MMMM88&&&&&    .
                 MMMM88&&&&&&&
     *           MM �������� &&
                 MMM88&&&&&&&&
                 'MMM88&&&&&&'
                   'MMM8&&&'      *
          |\___/|     /\___/\
          )     (     )    ~( .              '
         =\     /=   =\~    /=
           )===(       ) ~ (     ���������
          /     \     /     \    ��������� :)
          |     |     ) ~   (
         /       \   /     ~ \
         \       /   \~     ~/
  ___/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_
  |  |  |  |( (  |  |  | ))  |  |  |  |  |  |
  |  |  |  | ) ) |  |  |//|  |  |  |  |  |  |
  |  |  |  |(_(  |  |  (( |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |\)|  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
"@

Write-Host $successCats

$ok = $true
try {
    & $pythonPath/python.exe $PSScriptRoot/vk-music-import.py
} catch {
    $ok = $false
}

if ($ok) {
    Write-Host '[v] ������ �������� ���� ������';
} else {
    Write-Host '[x] ������ �������� ���� ������ � ��������';
}
Write-Host -NoNewLine '[!] ������� Enter, ����� �������...';
pause




