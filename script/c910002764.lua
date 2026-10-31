--カップ・オブ・エース
--Cup of Ace
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 37812118) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(37812118)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) or Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_EITHER,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(tp,1)
	local player=(coin==COIN_HEADS and tp) or (coin==COIN_TAILS and 1-tp) or nil
	if player then
		Duel.Draw(player,2,REASON_EFFECT)
	end
end