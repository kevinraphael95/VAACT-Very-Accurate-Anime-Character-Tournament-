--[VAACT] Sanctuaire Magique (Spell Sanctuary)
local s,id=GetID()

--ID de la carte d'origine (traitée comme elle) : à modifier ici si besoin
s.officiel=511000171

function s.initial_effect(c)
	--Traité comme Spell Sanctuary
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)

	--Activation : chaque joueur peut ajouter 1 Magie de son Deck à sa main
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--Tant que cette carte est face recto : les deux joueurs peuvent activer des Magies pendant le tour de l'adversaire
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_BECOME_QUICK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x3f,0x3f)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSpell))
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Vous
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	--Votre adversaire
	local g2=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_DECK,0,nil)
	if #g2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local sg=g2:Select(1-tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
	end
end