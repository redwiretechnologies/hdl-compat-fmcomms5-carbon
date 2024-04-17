from . import oot_builds

carbon_fmcomms5_dict = {  "carbon"   : {
                                         "images"    : ["fmcomms5"],
                                       },
                          "carbon-carp"   : {
                                             "images"    : ["fmcomms5"],
                                            }
                      }

oot_builds.merge(oot_builds.supported_oot, carbon_fmcomms5_dict)
