--[VAACT] Voleur d'Esprit
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local VOLEUR_ID = 910000063 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- 1) Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsFaceup() and c:IsMonster()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000) -- L'adversaire (1-tp) gagne 1000 LP
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	-- 1) L'adversaire gagne 1000 LP
	Duel.Recover(1-tp, 1000, REASON_EFFECT)
	
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	
	-- 2) Choix de l'effet
	local op=Duel.SelectOption(tp, aux.Stringid(id,0), aux.Stringid(id,1))
	
	if op==0 then
		-- Option A : Détruire le monstre
		Duel.Destroy(tc, REASON_EFFECT)
	else
		-- Option B : Permettre de sacrifier le monstre ce tour-ci
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE, 0) -- Dans les zones monstres
		e1:SetTarget(function(e, c) return c == tc end) -- Uniquement pour cette cible
		e1:SetValue(POS_FACEUP)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end