--タイラント・ダイナ・フュージョン
--Tyrant Dino Fusion
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 15543940) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(15543940)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_DINOWRESTLER),Fusion.OnFieldMat,nil,nil,nil,s.stage2)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DINOWRESTLER}
function s.stage2(e,tc,tp,mg,chk)
	if chk==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetValue(s.valcon)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function s.valcon(e,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0)
		return r&REASON_BATTLE+REASON_EFFECT~=0
	else
		return false
	end
end