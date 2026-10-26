--E・HERO ワイルドジャギーマン
--Elemental HERO Wildedge
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : Considérée comme la carte officielle (ID 10526791) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(10526791)
	c:RegisterEffect(e_add_code)
	-- ================================================================
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,86188410,59793705)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--attackall
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.material_setcode={SET_HERO,SET_ELEMENTAL_HERO}