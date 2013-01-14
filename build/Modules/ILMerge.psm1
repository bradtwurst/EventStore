$script:ilMergeModule = @{}
$script:ilMergeModule.ilMergePath = $null

function Merge-Assemblies {
	Param(
		$files,
		$outputFile,
		$exclude,
		$keyfile,
		$targetPlatform="v4,C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0"
	)

	$exclude | out-file ".\exclude.txt"

	$args = @(
		"/keyfile:$keyfile",
		"/internalize:exclude.txt", 
		"/xmldocs",
		"/wildcards",
		"/targetplatform:$targetPlatform",
		"/out:$outputFile") + $files

	if($ilMergeModule.ilMergePath -eq $null)
	{
		write-error "IlMerge Path is not defined. Please set variable `$ilMergeModule.ilMergePath"
	}

	& $ilMergeModule.ilMergePath $args 

	if($LastExitCode -ne 0) {
		write-error "Merge Failed"
	}
	
	remove-item ".\exclude.txt"
}

Export-ModuleMember -Variable "ilMergeModule" -Function "Merge-Assemblies"