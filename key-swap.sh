#!/bin/bash

# Change key for mechanical keyboard Vissles V84 pro
# Switch '§ ±' for '< >' 

CHECK=$(hidutil property --get "UserKeyMapping" | wc -l)

if [ $CHECK -eq 2 ] 
then
	hidutil property --set '{"UserKeyMapping":
    		[{"HIDKeyboardModifierMappingSrc":0x700000064,
      		"HIDKeyboardModifierMappingDst":0x700000087}]
	}' > /dev/null
	echo "Mechanical Keyboar MODE"
else
	hidutil property --set '{"UserKeyMapping":
    		[]
	}' > /dev/null
	echo "Default MODE"
fi
