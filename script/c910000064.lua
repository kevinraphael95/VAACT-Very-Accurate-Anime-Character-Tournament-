--[VAACT] Échange
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local ECHANGE_ID = 910000064 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- 1) Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- On vérifie que les deux joueurs ont au moins 1 carte en main
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 
			and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
	end
	
	-- On révèle les deux mains
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_HAND)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 1) Révéler les mains (pour l'animation et l'information)
	Duel.ConfirmCards(tp, Duel.GetFieldGroup(tp,0,LOCATION_HAND))
	Duel.ConfirmCards(1-tp, Duel.GetFieldGroup(tp,LOCATION_HAND,0))
	
	local g1 = Duel.GetFieldGroup(tp, LOCATION_HAND, 0) -- Ma main
	local g2 = Duel.GetFieldGroup(tp, 0, LOCATION_HAND) -- Sa main
	
	if #g1 == 0 or #g2 == 0 then return end
	
	-- 2) Chacun choisit une carte dans la main de l'autre
	-- L'adversaire choisit (l'IA ou le joueur réel)
	Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_ATOHAND)
	local sg2 = g1:Select(1-tp, 1, 1, nil)
	
	-- Toi tu choisis
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local sg1 = g2:Select(tp, 1, 1, nil)
	
	local tc1 = sg1:GetFirst() -- La carte de l'adversaire que TU prends
	local tc2 = sg2:GetFirst() -- La carte que L'ADVERSAIRE prend chez toi
	
	-- 3) Échanger les cartes (retour en main)
	if tc1 and tc2 then
		Duel.SendtoHand(tc1, tp, REASON_EFFECT)
		Duel.SendtoHand(tc2, 1-tp, REASON_EFFECT)
		
		-- Optionnel : On confirme les cartes échangées pour l'affichage
		Duel.ConfirmCards(tp, tc1)
		Duel.ConfirmCards(1-tp, tc2)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end