--[VAACT] Invocation à la Vitesse de l'Éclair (Thunderspeed Summon)
local s,id=GetID()

-- IDs officiels
local OFF_QUEEN = CARD_QUEEN_KNIGHT
local OFF_KING  = CARD_KING_KNIGHT
local OFF_JACK  = CARD_JACK_KNIGHT
-- IDs VAACT
local CUS_QUEEN = 910000021
local CUS_KING  = 910000031
local CUS_JACK  = 910000032

function s.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMING_BATTLE_START)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(function() return Duel.IsMainPhase() or Duel.IsBattlePhase() end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id,OFF_QUEEN,OFF_KING,OFF_JACK,CUS_QUEEN,CUS_KING,CUS_JACK}

-- Filtre pour chercher un monstre Niv 10 non-TÉNÈBRES avec ? ATK
function s.thfilter(c)
	return c:IsMonster() and c:GetTextAttack()==-2 and c:IsLevel(10)
		and c:IsAttributeExcept(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
-- Vérifie si on contrôle un Chevalier (officiel OU custom)
function s.hasKnight(tp, code_off, code_cus)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,code_off,code_cus)
end
function s.sfilter(c)
	return c:IsSummonable(true,nil) and c:IsLevel(10)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil)
	local b=s.hasKnight(tp,OFF_QUEEN,CUS_QUEEN)
		and s.hasKnight(tp,OFF_KING,CUS_KING)
		and s.hasKnight(tp,OFF_JACK,CUS_JACK)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil)
	local b=s.hasKnight(tp,OFF_QUEEN,CUS_QUEEN)
		and s.hasKnight(tp,OFF_KING,CUS_KING)
		and s.hasKnight(tp,OFF_JACK,CUS_JACK)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if not (a or b) then return end
	if (not a and b) or (b and Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local g2=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil)
				local tc=g2:GetFirst()
				if tc then
					Duel.Summon(tp,tc,true,nil)
				end
			end
		end
	elseif a then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end