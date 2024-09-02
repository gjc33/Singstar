Function EncodeURL($VLCPath){
    $VLCPath = $VLCPath -Replace "\\","/"
    $VLCPath = $VLCPath -Replace " ","%20"
    $VLCPath = $VLCPath -Replace "\(","%28"
    $VLCPath = $VLCPath -Replace "\)","%29"
    $VLCPath = $VLCPath -Replace "\{","%7B"
    $VLCPath = $VLCPath -Replace "\}","%7D"
    $VLCPath = $VLCPath -Replace "\[","%5B"
    $VLCPath = $VLCPath -Replace "\]","%5D"
    Return $VLCPath
}
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- 
$FolderPath = "C:\Users\garyc\Documents\GitHub\Singstar\"
$SongList = New-Object System.Collections.Generic.List[System.Object]

$data = Import-Csv -Path $(Join-Path $Folderpath "Singstar.csv") -Delimiter ","
ForEach ($Entry In $Data){
    Write-Host $Entry."Song Title"
    $Song = New-Object PSObject -Property @{
        Format       = $Entry.Format
        Disc         = $Entry.Disc
        Artist       = $Entry.Artist
        SongTitle    = $Entry."Song Title"
        UniqueArtist   = "$($Entry.Artist.ToUpper()):$($Entry.'Song Title'.ToUpper())"
        UniqueSong = "$($Entry.'Song Title'):$($Entry.Artist)"
    }
    $SongList.Add($Song)
}

$html = @'
<!DOCTYPE html>
<html>
    <title>Singstar Catalogue</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <body>

    <div class="w3-container">
        <h2>Singstar Catalogue</h2>
        <p>Click one of the tabs below to change sort order.</p>

        <div class="w3-bar w3-black">
          <button class="w3-bar-item w3-button tablink w3-red" onclick="openCity(event,'Artist')">Artist</button>
          <button class="w3-bar-item w3-button tablink" onclick="openCity(event,'SongTitle')">SongTitle</button>
          <button class="w3-bar-item w3-button tablink" onclick="openCity(event,'Disc')">Disc</button>
        </div>
'@

ForEach ($Sort In @("Artist","SongTitle","Disc")){
    Switch ($Sort){
        "Artist" {$html += "`n<div id='$($Sort)' class='w3-container w3-border city'>"; break;}
        default {$html += "`n<div id='$($Sort)' class='w3-container w3-border city' style='display:none'>"}
    }
    $html += "`n<h2>Sorted By $Sort</h2>"
    #$html += "`n<p> $Sort row goes Here </p>"

    $html += "`n<table border='1'>"
    
    
    Switch ($Sort) {
        "Artist" {
            $html += "`n<tr bgcolor='#9acd32'><th>Index</th><th>Artist</th><th>SongTitle</th><tr>"
            $Selection = $Songlist.UniqueArtist | Get-Unique | Sort
            break;
        }
         "Disc" {
            $html += "`n<tr bgcolor='#9acd32'><th>Index</th><th>Format</th><th>Disc</th><th>Artist</th><th>Songtitle</th><tr>"
            $Selection = $Songlist | Sort -Property @{expression = 'Format';descending = $true}, @{expression = 'Disc';descending = $false}, @{expression = 'Artist';descending = $false}, @{expression = 'SongTitle';descending = $false}
            break;
        }
       "SongTitle" {
            $html += "`n<tr bgcolor='#9acd32'><th>Index</th><th>SongTitle</th><th>Artist</th><tr>"
            $Selection = $Songlist.UniqueSong | Get-Unique | Sort
            break;
        }

    }

    ForEach ($Row In $Selection){
        If (!$Row.Format) {
            $html += "`n<tr><td>$($Selection.IndexOf($Row))</td><td>$($Row.Split(":")[0])</td><td>$($Row.Split(":")[1])</td></tr>"
        } Else {
            $html += "`n<tr><td>$($Selection.IndexOf($Row))</td><td>$($Row.Format)</td><td>$($Row.Disc)</td><td>$($Row.Artist)</td><td>$($Row.SongTitle)</td></tr>"
        }
    }
    
    
    $html += "`n</table>"
    $html += "`n</div>"
}

$html += @'
    </div>
        <script>
        function openCity(evt, cityName) {
          var i, x, tablinks;
          x = document.getElementsByClassName("city");
          for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";
          }
          tablinks = document.getElementsByClassName("tablink");
          for (i = 0; i < x.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" w3-red", "");
          }
          document.getElementById(cityName).style.display = "block";
          evt.currentTarget.className += " w3-red";
        }
        </script>

    </body>
</html>
'@


$html | Out-File $(Join-Path $FolderPath "index.html")
