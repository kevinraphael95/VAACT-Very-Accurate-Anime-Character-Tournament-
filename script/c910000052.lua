--[VAACT] Chapeaux Magiques (Magic Hats)
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local HAT_TOKEN_ID = 910001147 -- ID du Jeton Chapeau
local ILLUSION_ID = 910000070 -- ID de Illusion Envoûtante
local CERCLE_ID = 910000062 -- ID de Cercle Envoûtant
-- ==================================

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- On peut cibler n'importe quel monstre face recto qui peut être mis face cachée
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.canhat(tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,HAT_TOKEN_ID,0,TYPES_TOKEN,0,0,1,
		RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEDOWN_DEFENSE)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and s.canhat(tp)
			and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp)) then return end
	
	-- 1) Poser le monstre ciblé face cachée en défense
	if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end

	-- 2) Poser les 3 Jetons Chapeau
	local all=Group.FromCards(tc)
	for i=1,3 do
		local token=Duel.CreateToken(tp,HAT_TOKEN_ID)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
			all:AddCard(token)
		end
	end
	Duel.SpecialSummonComplete()

	-- 3) Mélanger les cartes posées (le monstre et les jetons)
	local mg=all:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if #mg>1 then Duel.ShuffleSetCard(mg) end

	-- 4) Si le monstre Posé quitte le Terrain ou est retourné face recto :
	--    détruire toutes les autres cartes (les jetons) posées par cet effet
	local others=all:Clone()
	others:RemoveCard(tc)
	others:KeepAlive()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetLabelObject(others)
	e1:SetOperation(s.desop)
	tc:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	tc:RegisterEffect(e2)
	
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(s.poscon)
	tc:RegisterEffect(e3)
end

function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousPosition(POS_FACEDOWN)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local dg=g:Filter(Card.IsOnField,nil)
	g:Clear()
	if #dg>0 then Duel.Destroy(dg,REASON_EFFECT) end
end