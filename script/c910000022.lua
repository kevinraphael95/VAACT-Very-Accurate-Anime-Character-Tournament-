--[VAACT] Multiplicateur (Multiply)
local s,id=GetID()

--ID du "Jeton Copie" : à modifier ici si besoin
s.jeton=910001145

function s.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
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

--Monstre face recto avec 500 ATK ou moins, copiable en Jeton
function s.filter(c,tp)
	return c:IsFaceup() and c:IsAttackBelow(500)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,s.jeton,nil,TYPES_TOKEN,
			c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	--Choisir le monstre à copier
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local mc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not mc then return end
	--Choisir combien de Jetons (autant que vous voulez)
	local n=ft
	if ft>1 then
		n=Duel.AnnounceNumberRange(tp,1,ft)
	end
	--Caractéristiques copiées
	local code=mc:GetOriginalCode()
	local race,att=mc:GetRace(),mc:GetAttribute()
	local atk,def=mc:GetAttack(),mc:GetDefense()
	local pos=mc:GetPosition()
	for i=1,n do
		local tc=Duel.CreateToken(tp,s.jeton)
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,pos) then
			--Même Nom
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--Même Type
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(race)
			tc:RegisterEffect(e2)
			--Même Attribut
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(att)
			tc:RegisterEffect(e3)
			--Même ATK/DEF
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(atk)
			tc:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(def)
			tc:RegisterEffect(e5)
			--Mêmes effets (s'il en a)
			tc:CopyEffect(code,RESET_EVENT|RESETS_STANDARD)
		end
	end
	Duel.SpecialSummonComplete()
end
