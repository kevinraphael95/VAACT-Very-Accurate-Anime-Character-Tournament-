--[VAACT] Alakan le Chevalier Harlequin (Arcana Knight Joker)
local s,id=GetID()

-- IDs regroupés en haut
local ID_REINE_VAACT=910000021
local ID_ROI_VAACT=910000031
local ID_VALET_VAACT=910000032
local ID_OFFICIEL_ALAKAN=6150044

function s.initial_effect(c)
	-- Considérée comme la carte officielle
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(ID_OFFICIEL_ALAKAN)
	c:RegisterEffect(e_add_code)
	--Fusion Material : Reine + Valet + Roi (codes custom OU officiels, copie de nom comprise)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,
		aux.FilterBoolFunctionEx(Card.IsCode,ID_REINE_VAACT,CARD_QUEEN_KNIGHT),
		aux.FilterBoolFunctionEx(Card.IsCode,ID_VALET_VAACT,CARD_JACK_KNIGHT),
		aux.FilterBoolFunctionEx(Card.IsCode,ID_ROI_VAACT,CARD_KING_KNIGHT))
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
s.listed_names={ID_REINE_VAACT,ID_ROI_VAACT,ID_VALET_VAACT,CARD_QUEEN_KNIGHT,CARD_JACK_KNIGHT,CARD_KING_KNIGHT}

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return (re:IsMonsterEffect() or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function s.filter(c,tpe)
	return c:IsType(tpe) and c:IsDiscardable()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=(re:GetActiveType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.DiscardHand(tp,s.filter,1,1,REASON_COST|REASON_DISCARD,nil,rtype)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end