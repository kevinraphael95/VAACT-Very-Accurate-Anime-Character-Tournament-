--サイバー・ツイン・ドラゴン
--Cyber Twin Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : Considérée comme la carte officielle (ID 74157028) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(74157028)
	c:RegisterEffect(e_add_code)
	-- ================================================================
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,CARD_CYBER_DRAGON,2)
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.material_setcode={SET_CYBER,SET_CYBER_DRAGON}