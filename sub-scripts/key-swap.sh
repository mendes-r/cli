#!/bin/bash

# Change key for mechanical keyboard Vissles V84 pro
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
#
# Switch '§ ±' for '< >' 
# Switch right Command key for right 'alt'

CHECK=$(hidutil property --get "UserKeyMapping" | wc -l)

if [ $CHECK -eq 2 ] 
then
	hidutil property --set '{"UserKeyMapping":
    		[
		{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000087},
		{"HIDKeyboardModifierMappingSrc":0x7000000E7, "HIDKeyboardModifierMappingDst":0x7000000E6}
		]
	}' > /dev/null
	echo "Mechanical Keyboar MODE"
else
	hidutil property --set '{"UserKeyMapping":
    		[]
	}' > /dev/null
	echo "Default MODE"
fi
