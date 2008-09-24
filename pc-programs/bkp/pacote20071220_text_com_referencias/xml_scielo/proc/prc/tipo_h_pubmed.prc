'd30d52d53d58d83'
'd480d85d12'
'd70d11'
/* FIXED 20040504 
			Roberta Mayumi Takenaka
			Solicitado por Solange email: 20040429
			Inclus�o de e-mail no arquivo XML.			
*/
(
	/* para resolver o problema do subcampo repetitivo */
	if p(v53) then
		'a53~<![CDATA[',v53^*,']]>',|^n|v53^n,|^i|v53^i,'~'
	fi

)
/* acrescentado 20050112 - v52 */
(
	/* para resolver o problema do subcampo repetitivo */
	if p(v52) then
		'a52~<![CDATA[',v52^*,']]>',|^d|v52^d,|^i|v52^i,'~'
	fi

)
(
if p(v121) then
 'a122~',s(f(100000+val(v121),1,0))*1.5,'~',
 fi
)

/* campos com conte�do de HTML */
(
	if p(v30) then
		'a30~<![CDATA[',v30,']]>','~'
	fi
)
(
	if p(v58) then
		if instr(v58,'^')=0 then
			'a58~<![CDATA[',v58,']]>','~'
		else 
			'a58~<![CDATA[',v58^*,']]>','^d',v58^d,'~'
		fi
	fi
)
(
	if p(v83) then
		'a83~<![CDATA[',v83^a,']]>',|^l|v83^l,'~'
	fi
)
(
	if p(v12) then
		'a12~<![CDATA[',v12^*,' ]]>',|^l|v12^l,'~'
	fi
)
(
	if p(v85) then
		'a85~<![CDATA[',v85^k,']]>',|^l|v85^l,'~'
/*		'a85^k~<![CDATA[',v85^k,']]>',|^k|v85^k,'~' */
	fi
)


/* 36,480,880,936,121 */

(
 if p(v480) then
 'a480~<![CDATA[',v480,']]>~', 
 fi
 )

(if p(v933) then
 'a933~<![CDATA[',v933,']]>~', 
 fi
 ) 

ref(l('tipo=I'),
 (
 if p(v36) then
 'a36~',v36,'~', 
 fi
 )
 (
 if p(v36) then
 'a37~',s(f(10000+val(v36*4.2),1,0))*1.4,'~',
 fi
)
)

ref(l('tipo=O'),
(
 if p(v91) then
 'a91~',v91,'~', 
 fi
 )
 )
/*
'a19~',
ref(['TITLE']l(['TEMP_TITLE']v35),
v691),
'~',

'a15~',
ref(['TITLE']l(['TEMP_TITLE']v35),
v301),
'~',
*/

/* FIXED 20040504 
			Roberta Mayumi Takenaka
			Solicitado por Solange email: 20040429
			Inclus�o de e-mail no arquivo XML.			
			*/
('a70{',
	if p(v70^e) then
		replace(v70,s('^e',v70^e), s('^e',v9072))
	else
		v70
	fi
,'{')

(
	if p(v11) then
		'a11~<![CDATA[',v11,']]>~'
	fi
)