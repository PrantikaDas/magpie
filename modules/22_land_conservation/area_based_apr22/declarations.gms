*** |  (C) 2008-2022 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

scalars
 s22_shift number of 5-year age-classes corresponding to current time step length (1)
;

parameters
 p22_conservation_area(t,j,land)                          Total land conservation area for all land types (mio. ha)
 p22_restoration_target(t,j,land)                         Hypothetical restoration target area for all land types (mio. ha)
 pm_land_conservation(t,j,land,consv_type)				  Land protection and restoration for all land types (mio. ha)
 p22_conservation_fader(t_all)			                  Land conservation fader (1)
 p22_consv_shr_ini(j,consv22_all)   		              Land conservation share for primforest, secdforest and other land (1)
 p22_consv_shr(t,j,consv22_all,land_natveg)               Land conservation share for primforest, secdforest and other land (1)
 p22_past_restore_pot(t,j)                                Potential pasture restoration area (mio. ha)
 p22_other_restore_pot(t,j)                               Potential other land restoration area (mio. ha)
 p22_country_weight(i)	                  		          Land conservation country weight per region (1)
 p22_country_dummy(iso)		                              Dummy parameter indicating whether country is affected by selected land conservation policy (1)
 i22_land_iso(iso)								                Total land area at ISO level (mio. ha)
 p22_min_forest(t,j) 			                          Minimum forest stock [land conservation for climate mitigation] (Mha)
 p22_min_other(t,j)      		                          Minimum other land stock [land conservation for climate mitigation] (Mha)
;

equations
 q22_natveg_conservation(j)                     Total natural vegetation conservation constraint (mio. ha)
 q22_min_forest(j)					            Minimum forest land constraint (mio. ha)
 q22_min_other(j)                               Minimum other land constraint (mio. ha)
;



*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 oq22_min_forest(t,j,type) Minimum forest land constraint (mio. ha)
 oq22_min_other(t,j,type)  Minimum other land constraint (mio. ha)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################
