--スーパービークロイド－ジャンボドリル
--Super Vehicroid Jumbo Drill
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 36256625) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(36256625)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,44729197,71218746,99861526)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end
s.material_setcode=SET_ROID