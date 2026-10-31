--ペンデュラム・フュージョン
--Pendulum Fusion
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 65646587) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(65646587)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Fusion.CreateSummonEff(c,nil,Fusion.OnFieldMat,s.fextra)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function s.fextra(e,tp,mg)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==2 then
		return Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_PZONE,0,nil)
	end
end