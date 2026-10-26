--[VAACT] Kuribeh
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=34419588
--"Kuribandit", invoqué depuis l'Extérieur du Duel : à modifier ici si besoin
s.kuribandit=910000030
--Cartes à Sacrifier avec Kuribeh (1 de chaque, depuis la main et/ou le Terrain)
s.materiaux={44632120,71036835,7021574,CARD_KURIBOH}  --Kuribah, Kuribeille, Kuribou, Kuriboh

s.listed_names={s.kuribandit}
for _,code in ipairs(s.materiaux) do table.insert(s.listed_names,code) end
s.listed_series={SET_KURIBOH}

function s.initial_effect(c)
	--Traité comme Kuribeh officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Sacrifier cette carte + 1 Kuribah, Kuribeille, Kuribou et Kuriboh : Invoquer 1 Kuribandit depuis l'Extérieur du Duel
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id) --1 "Kuribeh" par tour
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

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

function s.spcfilter(c,tp)
	return c:IsCode(table.unpack(s.materiaux)) and c:IsReleasable()
		and (c:IsControler(tp) or c:IsFaceup())
end
--Exactement 1 de chaque matériel
function s.rescon(sg,tp,mg)
	for _,code in ipairs(s.materiaux) do
		if not sg:IsExists(Card.IsCode,1,nil,code) then return false end
	end
	return true
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
			and Duel.CheckReleaseGroupCost(tp,s.spcfilter,4,true,s.rescon,c,tp)
	end
	local sg=Duel.SelectReleaseGroupCost(tp,s.spcfilter,4,4,true,s.rescon,c,tp)+c
	Duel.Release(sg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.CreateToken(tp,s.kuribandit)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
