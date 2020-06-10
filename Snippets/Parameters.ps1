function FunctionName
{
    [CmdletBinding()]
    param (
    
        [Parameter(Mandatory = $Boolean,
            Position = 1,
            ParameterSetName = "String",
            ValueFromPipeline = $Boolean,
            ValueFromPipelineByPropertyName = $Boolean,
            ValueFromRemainingArguments = Boolean)]
        [Alias("String")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("String1", "String2")]
        [ValidateCount(Int_min, Int_max)]
        [ValidateLength(Int_min, Int_max)]
        [ValidateRange(Int_min, Int_max)]
        [ValidatePattern("RegexPattern")]
        [ValidateScript( { Expression })]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [Type[]]
        $Name
    )

    
}