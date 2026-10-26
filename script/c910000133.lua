--[VAACT] Forme du Chaos (Chaos Form)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=21082832

s.listed_series={SET_CHAOS}
s.listed_names={CARD_DARK_MAGICIAN,CARD_BLUEEYES_W_DRAGON}

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Invocation Rituelle : Sacrifier des monstres (main ou Terrain) dont le Niveau total est exactement égal
	local e1=Ritual.AddProcEqual{handler=c,filter=s.ritualfil}
	if e1 then e1:SetDescription(aux.Stringid(id,0)) end
	--Si "Dragon Blanc aux Yeux Bleus" ou "Magicien Sombre" est dans votre Cimetière : aucun Sacrifice nécessaire
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
--Monstre Rituel "Chaos" ou "Soldat du Lustre Noir"
function s.ritualfil(c)
	return c:IsSetCard({SET_CHAOS,SET_BLACK_LUSTER_SOLDIER}) and c:IsRitualMonster()
end
function s.gyfilter(c)
	return c:IsMonster() and c:IsCode(CARD_DARK_MAGICIAN,CARD_BLUEEYES_W_DRAGON)
end
function s.spfilter(c,e,tp)
	return s.ritualfil(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
