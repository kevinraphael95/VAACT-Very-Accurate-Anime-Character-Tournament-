--[VAACT] Kuribabylon
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=70914287
--Monstres à Invoquer depuis le Cimetière (1 de chaque) : Kuribah, Kuribeille, Kuribou, Kuribeh, Kuriboh
s.membres={44632120,71036835,7021574,34419588,CARD_KURIBOH}

s.listed_names={}
for _,code in ipairs(s.membres) do table.insert(s.listed_names,code) end
s.listed_series={SET_KURIBOH}

function s.initial_effect(c)
	--Traité comme Kuribabylon officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--+300 ATK/DEF par monstre "Kuri" sur le Terrain et au Cimetière
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Main Phase : renvoyer à l'Extérieur du Duel, Invoquer les 5 monstres depuis le Cimetière
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--Idem pendant votre Battle Phase (Rapide)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(s.spcon)
	c:RegisterEffect(e5)

	--Règle : ne doit pas être dans le Main Deck au début du Duel
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_STARTUP)
		ge1:SetOperation(s.startop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsOriginalCode,0,LOCATION_DECK,LOCATION_DECK,nil,id)
	if #g>0 then
		Duel.Exile(g,REASON_RULE)
	end
end

function s.atkfilter(c)
	return c:IsSetCard(SET_KURIBOH) and c:IsMonster() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE|LOCATION_GRAVE,0,nil)*300
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase() and Duel.GetCurrentChain()==0
end
function s.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetMZoneCount(tp,c)<#s.membres or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return false end
		for _,code in ipairs(s.membres) do
			if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,code) then return false end
		end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#s.membres,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Exile(c,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<#s.membres or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
		local sg=Group.CreateGroup()
		for _,code in ipairs(s.membres) do
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,code)
			if #g==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg:Merge(g:Select(tp,1,1,nil))
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
