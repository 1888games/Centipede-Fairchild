		MAC Set_ISAR
			lisu	[[{1}] >> 3]
			lisl	[[{1}] & %111]
		ENDM

		MAC Load_Scratch
			lisu	[[{1}] >> 3]
			lisl	[[{1}] & %111]
			lr A, S
		ENDM

		MAC Save_Scratch
			lisu	[[{1}] >> 3]
			lisl	[[{1}] & %111]
			lr S, A
		ENDM

		MAC Store_A_DC0
			st
		ENDM

		MAC Load_Ram 
			dci [{1}]
			lm
		ENDM 

		MAC Store_Ram 
			dci [{1}]
			st
		ENDM 

		MAC Inc_Ram
			dci [{1}]
			lm
			inc
			dci [{1}]
			st
		ENDM

		MAC Dec_Ram
			dci [{1}]
			lm
			ai 255
			dci [{1}]
			st
		ENDM


		MAC Reset_Ram
			dci [{1}]
			clr
			st
		ENDM

		MAC GetCellContents

			lr a, 1
			sl 1

			dci RowLookup
			adc
			lm
			lr	Qu, A
			lm
			lr	Ql, A
			lr	DC, Q

			lr a, 0
			adc
			lm

		ENDM

		

		MAC GetFromArray_A
			dci [{1}]
			adc
			lm
		ENDM

		MAC SaveToArray_A
			dci [{1}]
			adc
			li [{2}]
			st
		ENDM

		MAC SaveR0ToArray_A
			dci [{1}]
			adc
			lr a, 0
			st
		ENDM


		MAC Set_DC0_Address
			dci [{1}]
		ENDM

		MAC Load_To_A
			li [{1}]
		END

		MAC Set_A_Zero
			clr
		ENDM

		MAC Inc_Scratch
			lisu	[[{1}] >> 3]
			lisl	[[{1}] & %111]
			lr A, S
			inc
			lr S, A

		ENDM

		MAC Reset_Scratch

			lisu	[[{1}] >> 3]
			lisl	[[{1}] & %111]
			clr
			lr S, A

		ENDM

		MAC GetRandom

			dci RAM.Seed
			lm
			dci RandomLookup
			adc
			lm
			lr 0, A
			Inc_Ram RAM.Seed
			lr A, 0

		ENDM

		MAC Load_R
			lr A, [{1}]
		ENDM

		MAC Store_R
			lr [{1}], A
		ENDM

		MAC Inc_R
			Load_R [{1}]
			inc
			Store_R [{1}]
		ENDM


		MAC Increment_Indexed_Ram
			dci [{1}]
			adc
			lr h, dc0
			lm
			inc
			lr dc0, h
			st
		ENDM

		MAC Decrement_Indexed_Ram
			dci [{1}]
			adc
			lr h, dc0
			lm
			ai 255
			lr dc0, h
			st
		ENDM


		MAC Reset_Indexed_Ram
			dci [{1}]
			adc
			clr
			st
		ENDM

		MAC Clear16Bytes

			dci [{1}]
			clr
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
			st
		ENDM


		