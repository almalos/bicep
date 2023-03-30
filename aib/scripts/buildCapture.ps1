#Variables
$resourceGroupName = "rg-avdimage"
$imageTemplateName = "avd10ImageTemplate01"

#Build image
Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -NoWait

#Get build status
$buildStatus=$(Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName)
$buildStatus | Format-List -Property *
$buildStatus.LastRunStatusRunState 
$buildStatus.LastRunStatusRunSubState