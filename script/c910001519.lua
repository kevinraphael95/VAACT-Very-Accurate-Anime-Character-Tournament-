--ペア・サイクロイド
--Pair Cycroid
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 16114248) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(16114248)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
end
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,tp))
end
function s.fusfilter(c,code,fc,tp)
	return c:IsSummonCode(fc,SUMMON_TYPE_FUSION,tp,code) or c:IsHasEffect(511002961)
end