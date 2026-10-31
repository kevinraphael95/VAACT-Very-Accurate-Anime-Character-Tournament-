--BF－逆風のガスト
--Blackwing - Gust the Backblast
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 52869807) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(52869807)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
end
s.listed_series={SET_BLACKWING}
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
end
function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local d=Duel.GetAttackTarget()
	local tp=e:GetHandlerPlayer()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and d and d:IsControler(tp) and d:IsSetCard(SET_BLACKWING)
end
function s.atktg(e,c)
	return c==Duel.GetAttacker()
end