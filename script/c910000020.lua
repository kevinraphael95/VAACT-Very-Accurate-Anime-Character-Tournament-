--[VAACT] Magicien Marron Expérimenté (Skilled Brown Magician)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=88232397
--IDs des cartes ajoutées depuis l'Extérieur du Duel : à modifier ici si besoin
s.multiplicateur=910000022   --"Multiplicateur" (Multiply)
s.crepuscule=910000023       --"Crépuscule à Cinq Étoiles"

function s.initial_effect(c)
	--Traité comme Skilled Brown Magician officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	c:EnableCounterPermit(COUNTER_SPELL)
	c:SetCounterLimit(COUNTER_SPELL,1)
	--Placer un Compteur Magie quand une Magie s'est résolue
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	--Retirer 1 Compteur : +1500 ATK / +1 Niveau, ou ajouter 1 carte depuis l'extérieur du Duel
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)  --1 fois par tour
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.counter_place_list={COUNTER_SPELL}
s.listed_names={s.multiplicateur,s.crepuscule}

function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsSpellEffect() and c:GetFlagEffect(1)>0 then
		c:AddCounter(COUNTER_SPELL,1)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_SPELL,1,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_SPELL,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=Duel.SelectEffect(tp,
		{true,aux.Stringid(id,1)},
		{true,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
		--+1 Niveau
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		--+1500 ATK
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1500)
		c:RegisterEffect(e2)
	else
		--Ajouter 1 "Multiplicateur" ou "Crépuscule à Cinq Étoiles" depuis l'Extérieur du Duel
		local sel=Duel.SelectEffect(tp,
			{true,aux.Stringid(id,3)},
			{true,aux.Stringid(id,4)})
		local code=(sel==1) and s.multiplicateur or s.crepuscule
		local tc=Duel.CreateToken(tp,code)
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end