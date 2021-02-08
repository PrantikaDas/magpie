*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations

*' Timber production cost covering cost of harvest as well as the cost incurred by
*' utilizing free variable with a very high cost. Ideally this free variable is only
*' used when there is no other way to meet timber demand. To make sure that timber plantations
*' are harvested at rotation age, the economically optimal point in time, we assume zero
*' costs for production from timber plantations, and higher costs for for production from
*' natural vegetation.

q73_cost_timber(i2)..
                    vm_cost_timber(i2)
                    =e=
                    v73_cost_hvarea(i2)
                    + sum((cell(i2,j2),land_natveg,ac,kforestry), v73_prod_natveg(j2,land_natveg,ac,kforestry) * s73_timber_prod_cost)
                    + sum(cell(i2,j2), v73_prod_residues(j2) * 2)
                    + sum((cell(i2,j2),kforestry), v73_prod_heaven_timber(j2,kforestry) * s73_free_prod_cost)
                    ;

*' Harvested cost is defined as the cost incurred while removing biomass from forests.
*' Harvestig natural vegetation is made less attractive to the model by providing higher
*' harvesting costs. This is to mimic the difficulties in accessing primary and secondary
*' forests.

q73_cost_hvarea(i2)..
                    v73_cost_hvarea(i2)
                    =e=
                    sum((ct,cell(i2,j2),ac_sub), vm_hvarea_forestry(j2,ac_sub)   * p73_timber_harvest_cost(ct,j2,ac_sub,"forestry"))
                  + sum((ct,cell(i2,j2),ac_sub), vm_hvarea_secdforest(j2,ac_sub) * p73_timber_harvest_cost(ct,j2,ac_sub,"secdforest"))
                  + sum((ct,cell(i2,j2),ac_sub), vm_hvarea_other(j2, ac_sub)     * p73_timber_harvest_cost(ct,j2,ac_sub,"other"))
                  + sum((ct,cell(i2,j2)),        vm_hvarea_primforest(j2)        * p73_timber_harvest_cost(ct,j2,"acx","primforest"))
                    ;

*' The following equations describes cellular level production (in dry matter) of
*' woody biomass `vm_prod_reg` as the sum of the cluster level production of
*' timber coming from 'v73_prod_forestry' and 'v73_prod_natveg'. When production
*' capabilities are exhausted, the model can produce roundwood without using any
*' land resources but by paying a very high cost ('s73_free_prod_cost').


*' The production equation is split in two parts, one each for industrial roundwood
*' and wood fuel production. Woodfuel production, in addition to usual production
*' channels, can also use residues left from industrial roundwood harvest for meeting
*' overall wood fuel production targets.

q73_prod_wood(j2)..
  vm_prod(j2,"wood")
  =e=
  sum(ac_sub, v73_prod_forestry(j2,ac_sub,"wood"))
  +
  sum((land_natveg,ac_sub),v73_prod_natveg(j2,land_natveg,ac_sub,"wood"))
  +
  v73_prod_heaven_timber(j2,"wood");

q73_prod_woodfuel(j2)..
  vm_prod(j2,"woodfuel")
  =e=
  sum(ac_sub, v73_prod_forestry(j2,ac_sub,"woodfuel"))
  +
  sum((land_natveg,ac_sub),v73_prod_natveg(j2,land_natveg,ac_sub,"woodfuel"))
  +
  v73_prod_residues(j2)
  +
  v73_prod_heaven_timber(j2,"woodfuel");

*' Production of residues is calculated based on `s73_residue_ratio`. This fraction
*' of industrial roundwood production is assumed to be lost during harvesting processes.
*' USDA reports that ca. 30% of roundwood harvested can be residues (@oswalt2019forest).
*' Not all of this residue is recoverwed from forest and we assume 50% of residue
*' removal based on @pokharel2017factors .

q73_prod_residues(j2)..
  v73_prod_residues(j2)
  =l=
  vm_prod(j2,"wood") * s73_residue_ratio
  ;

** Timber plantation
*' Woody biomass production from timber plantations is calculated by multiplying the
*' area under production with corresponding yields of plantation forests, divided by the timestep length.

q73_prod_forestry(j2,ac_sub)..
                         sum(kforestry, v73_prod_forestry(j2,ac_sub,kforestry))
                         =e=
                         vm_hvarea_forestry(j2,ac_sub) * sum(ct, pm_timber_yield(ct,j2,ac_sub,"forestry")) / m_timestep_length_forestry;

** Secondary forest
*' Woody biomass production from secondary forests is calculated by multiplying the
*' area under production with corresponding yields of secondary forests, divided by the timestep length.

q73_prod_secdforest(j2,ac_sub)..
                           sum(kforestry, v73_prod_natveg(j2,"secdforest",ac_sub,kforestry))
                           =e=
						    vm_hvarea_secdforest(j2,ac_sub) * sum(ct,pm_timber_yield(ct,j2,ac_sub,"secdforest")) / m_timestep_length_forestry;

** Primary forest
*' Woody biomass production from primary forests is calculated by multiplying the
*' area under production with corresponding yields of primary forests, divided by the timestep length.

q73_prod_primforest(j2)..
                           sum(kforestry, v73_prod_natveg(j2,"primforest","acx",kforestry))
                           =e=
                           vm_hvarea_primforest(j2) * sum(ct, pm_timber_yield(ct,j2,"acx","primforest")) / m_timestep_length_forestry;

** Other land
*' Wood-fuel production from other land is calculated by multiplying the area under
*' production with corresponding yields of other land, divided by the timestep length.
*' Wood production from other landis not allowed.

q73_prod_other(j2,ac_sub)..
                          v73_prod_natveg(j2,"other",ac_sub,"woodfuel")
                          =e=
                          vm_hvarea_other(j2,ac_sub) * sum(ct, pm_timber_yield(ct,j2,ac_sub,"other")) / m_timestep_length_forestry
                          ;

*** EOF equations.gms ***
