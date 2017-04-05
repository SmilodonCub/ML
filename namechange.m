for i = 1:size( bearsimilarity,1 )
    entry = bearsimilarity{ i,1 };
    entry_split = regexp(entry, '\_', 'split');
    new_name = [ char(entry_split(1)) 'Bear_' char(entry_split(2)) ];
    bearsimilarity{ i,1 } = new_name;
end