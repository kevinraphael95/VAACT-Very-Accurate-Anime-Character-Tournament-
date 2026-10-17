--[VAACT] Monster Recovery
local s,id=GetID()
function s.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--Votre main + les monstres que vous contrôlez
function s.getgroup(tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g:Merge(Duel.GetFieldGroup(tp,LOCATION_MZONE,0))
	return g:Filter(Card.IsAbleToDeck,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=s.getgroup(tp)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,#g+1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g+1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=s.getgroup(tp)
	if #g==0 then return end
	--Mélanger la main et les monstres dans le Deck
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct==0 then return end
	Duel.ShuffleDeck(tp)
	--Piocher autant de cartes que de cartes mélangées +1
	if Duel.IsPlayerCanDraw(tp,ct+1) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct+1,REASON_EFFECT)
	end
end