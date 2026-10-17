--[VAACT] Illusion Envoûtante
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local ILLUSION_ID = 910000070 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsControler(1-s:GetOwner():GetControler()) -- (Astuce pour cibler l'adversaire)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 1) Perd 500 ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) -- Effet permanent tant que la cible est sur le terrain
		tc:RegisterEffect(e1)
		
		-- 2) Annule les effets
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
		-- (Optionnel) Il faut aussi annuler l'effet du monstre s'il en a un autre.
		-- Dans EDOPro, EFFECT_DISABLE bloque bien les effets activés.
	end
end