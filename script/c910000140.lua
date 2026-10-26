--[VAACT] Miroir Magique de Prestidigitation (Magical Trick Mirror)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=85758066

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Quand l'adversaire déclare une attaque : cibler 1 Magie de son Cimetière, activer cette carte avec son effet
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.filter(c)
	return c:IsSpell() and c:CheckActivateEffect(false,true,false)~=nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
	local te=tc:CheckActivateEffect(false,true,false)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	--La Magie ciblée sert de modèle : ses propres cibles sont choisies à sa place
	Duel.ClearTargetCard()
	Duel.ClearOperationInfo(0)
	tc:CreateEffectRelation(e)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	if not te:GetHandler():IsRelateToEffect(e) then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	--Si 1 monstre a été Invoqué Spécialement en Position de Défense : les monstres de l'adversaire doivent l'attaquer
	local og=Duel.GetOperatedGroup()
	local sc=og:GetFirst()
	if sc and #og==1 and sc:IsLocation(LOCATION_MZONE) and sc:IsControler(tp)
		and sc:IsDefensePos() and sc:IsSpecialSummoned() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCondition(s.effcon)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e2:SetValue(s.atklimit)
		sc:RegisterEffect(e2)
	end
end
function s.effcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function s.atklimit(e,c)
	return c==e:GetHandler()
end
