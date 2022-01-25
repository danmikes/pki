Deze scripts dienen ter installatie en beheer van Certificate Authority

deze stap voert men alleen uit bij de allereerste procedure
0. login met 'tempUser' op Virtual Machine

1. 'RUN'
   '00-execution-policy'
   '10-map-drives'
   '20-create-users'
   '31-create-hsm-registry'
   '30-install-adcs-role'
   '40-copy-capolicy'
   '40-install-ca'
   '51-configure-ca-aia-extensions'
   '52-configure-ca-cdp-extensions'

   '60-backup-ca'
   '61-copy-files'

1. 'TEST'
   'invoke-pester' ==
   '10-map-drives.Tests'
   '20-create-users.Tests'
   '31-create-hsm-registry.Tests'
   '30-install-adcs-role.Tests'
   '40-copy-capolicy.Tests'
   '40-install-ca.Tests'
   '51-configure-ca-aia-extensions.Tests'
   '52-configure-ca-cdp-extensions.Tests'

1. 'CLEAN'
   '90-utils-remove-ca'
   '91-utils-remove-files'
   '92-utils-remove-maps'
   '93-utils-remove-users'
