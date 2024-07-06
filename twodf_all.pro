pro twodf_all
;radec
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_15h06m-15d01m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_14h58m-15d01m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h45m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_15h24m-15d01m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_22h39m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h36m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_22h49m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_22h58m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h17m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h26m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h54m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_22h30m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_22h20m-26d05m.mer'
;twodf_radec,'/media/ben/dur-ext4/jun_run/fields/twodf_23h07m-26d05m.mer'

;match
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_15h06m-15d01m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_15h06m-15d01m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_14h58m-15d01m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_14h58m-15d01m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h45m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h45m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_15h24m-15d01m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_15h24m-15d01m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_22h39m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_22h39m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h36m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h36m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_22h49m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_22h49m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_22h58m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_22h58m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h17m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h17m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h26m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h26m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h54m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h54m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_22h30m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_22h30m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_22h20m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_22h20m-26d05m_coords_wise-in.tbl'
;twodf_match,'/media/ben/dur-ext4/jun_run/coords/twodf_23h07m-26d05m_coords.mer','/media/ben/dur-ext4/jun_run/wise-out/twodf_23h07m-26d05m_coords_wise-in.tbl'


;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_22h58m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_22h58m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_15h24m-15d01m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_15h24m-15d01m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_22h20m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_22h20m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_14h58m-15d01m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_14h58m-15d01m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_22h49m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_22h49m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h07m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h07m-26d05m_coords_wise_match.mer 
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_15h06m-15d01m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_15h06m-15d01m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_22h39m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_22h39m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h36m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h36m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h45m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h45m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h26m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h26m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h54m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h54m-26d05m_coords_wise_match.mer 
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_23h17m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_23h17m-26d05m_coords_wise_match.mer
;stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" action=identify ifmt=fits ofmt=fits in=/media/ben/dur-ext4/jun_run/wise/twodf_22h30m-26d05m_coords_wise.mer out=/media/ben/dur-ext4/jun_run/match/twodf_22h30m-26d05m_coords_wise_match.mer

;sn
;(u3_flux/pow(u3_ivar,-0.5))+(g3_flux/pow(g3_ivar,-0.5))+(r3_flux/pow(r3_ivar,-0.5))+(i3_flux/pow(i3_ivar,-0.5))+(z3_flux/pow(z3_ivar,-0.5))

;remove duplicates
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h54m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_14h58m-15d01m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h17m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h45m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h07m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_22h30m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_15h24m-15d01m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_22h58m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_22h39m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h36m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_15h06m-15d01m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_22h49m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_22h20m-26d05m_coords_wise_match_SN.mer'
;remove_duplicates,'/media/ben/dur-ext4/jun_run/match/twodf_23h26m-26d05m_coords_wise_match_SN.mer'

;pqso
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_22h39m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_22h30m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h36m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h26m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_22h20m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h07m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h45m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_22h58m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_22h49m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_15h06m-15d01m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h54m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_14h58m-15d01m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_23h17m-26d05m_coords_wise_match_SN_noduplicates.mer'
;twodf_pqso,'/media/ben/dur-ext4/jun_run/match/twodf_15h24m-15d01m_coords_wise_match_SN_noduplicates.mer'

;selection
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_14h58m-15d01m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_15h06m-15d01m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_15h24m-15d01m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_22h20m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_22h30m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_22h49m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_22h58m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h07m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h17m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h26m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h36m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h45m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'
twodf_selection,'/media/ben/dur-ext4/jun_run/pqso/twodf_23h54m-26d05m_coords_wise_match_SN_noduplicates_xdqso.mer'



end
