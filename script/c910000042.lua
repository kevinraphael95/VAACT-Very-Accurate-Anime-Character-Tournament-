--[VAACT] Card of Sanctity
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=42664989
--Nombre de cartes en main à atteindre : à modifier ici si besoin
s.cartes=6

function s.initial_effect(c)
	--Traitée comme Card of Sanctity officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Chaque joueur pioche jusqu'à avoir 6 cartes en main
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--Si la carte est encore en main, elle n'y sera plus à la résolution
	local adj=c:IsLocation(LOCATION_HAND) and 1 or 0
	local ct1=s.cartes-(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-adj)
	local ct2=s.cartes-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then
		return (ct1>0 and Duel.IsPlayerCanDraw(tp,ct1))
			or (ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2))
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.max(ct1,0))
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,math.max(ct2,0))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht<s.cartes then
		Duel.Draw(tp,s.cartes-ht,REASON_EFFECT)
	end
	ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht<s.cartes then
		Duel.Draw(1-tp,s.cartes-ht,REASON_EFFECT)
	end
end
