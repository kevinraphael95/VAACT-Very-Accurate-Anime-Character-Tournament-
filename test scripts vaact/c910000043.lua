--[VAACT] Monster Recovery
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=93108433

function s.initial_effect(c)
	--Traitée comme Monster Recovery officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Mélanger votre main + vos monstres dans le Deck ; piocher autant de cartes +1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--Votre main (sans cette carte) + les monstres que vous contrôlez
function s.getgroup(tp,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g:Merge(Duel.GetFieldGroup(tp,LOCATION_MZONE,0))
	g:RemoveCard(c)
	return g:Filter(Card.IsAbleToDeck,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=s.getgroup(tp,e:GetHandler())
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,#g+1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g+1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=s.getgroup(tp,e:GetHandler())
	if #g==0 then return end
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct==0 then return end
	Duel.ShuffleDeck(tp)
	if Duel.IsPlayerCanDraw(tp,ct+1) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct+1,REASON_EFFECT)
	end
end
