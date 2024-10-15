$a = Get-ChildItem "C:\OldAttachments" -Recurse -Directory -ErrorAction SilentlyContinue
$a | ForEach-Object {
    $dirName = $_.FullName
    $acls = Get-Acl $dirName -ErrorAction SilentlyContinue | Select -ExpandProperty Access | Where-Object {
        $_.FileSystemRights -match "Write" -and $_.IdentityReference -match "authenticated users|everyone|$env:username"
    }
    if ($acls -ne $null) {
        [pscustomobject]@{
            DirectoryName = $dirName
            Users         = $acls | Select -ExpandProperty IdentityReference
        }
    }
}
$a | Format-Table -AutoSize
