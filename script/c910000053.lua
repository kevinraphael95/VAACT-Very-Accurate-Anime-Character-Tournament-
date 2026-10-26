--[VAACT] Dark Magic Curtain
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=99789342

function s.initial_effect(c)
	--Traité comme Dark Magic Curtain officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Payer la moitié de vos LP : Invoquer 1 Magicien depuis le Deck, puis l'adversaire peut faire de même depuis sa main
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH) --1 "Rideau de Magie Noire" par tour
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=math.floor(Duel.GetLP(tp)/2)
	if chk==0 then return Duel.CheckLPCost(tp,lp) end
	Duel.PayLPCost(tp,lp)
end
function s.spfilter(c,e,p)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,p,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		--Puis l'adversaire peut payer la moitié de ses LP
		local p=1-tp
		local lp=math.floor(Duel.GetLP(p)/2)
		if Duel.CheckLPCost(p,lp) and Duel.GetLocationCount(p,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,p,LOCATION_HAND,0,1,nil,e,p) then
			Duel.BreakEffect()
			if Duel.SelectYesNo(p,aux.Stringid(id,0)) then
				Duel.PayLPCost(p,lp)
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(p,s.spfilter,p,LOCATION_HAND,0,1,1,nil,e,p)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
				end
			end
		end
	end
end
