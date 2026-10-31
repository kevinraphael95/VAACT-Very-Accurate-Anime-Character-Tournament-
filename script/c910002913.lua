--ポセイドン・オオカブト
--Great Poseidon Beetle
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 75292259) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(75292259)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(s.atcon)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and bc and bc:IsRelateToBattle()
		and bc:GetBattlePosition()==POS_FACEUP_ATTACK and c:CanChainAttack(3)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack(e:GetHandler():GetBattleTarget())
end