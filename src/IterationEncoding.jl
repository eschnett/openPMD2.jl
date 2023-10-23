"""
    @enum IterationEncoding begin
        IterationEncoding_fileBased
        IterationEncoding_groupBased
        IterationEncoding_variableBased
    end
"""
@enum IterationEncoding begin
    IterationEncoding_fileBased = 0
    IterationEncoding_groupBased = 1
    IterationEncoding_variableBased = 2
end
export IterationEncoding, IterationEncoding_fileBased, IterationEncoding_groupBased, IterationEncoding_variableBased
