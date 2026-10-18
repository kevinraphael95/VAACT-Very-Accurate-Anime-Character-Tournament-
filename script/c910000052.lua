--[VAACT] Magical Hats
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=81210420
--"Jeton Chapeau" : à modifier ici si besoin
s.jeton=910001147
--Pièges "Envoûtants" posables depuis le Deck : à modifier ici si besoin
s.pieges={910000070,910000062}  --Illusion Envoûtante, Cercle Envoûtant

s.listed_names={s.jeton,table.unpack(s.pieges)}

function s.initial_effect(c)
	--Traitée comme Magical Hats officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Poser 1 monstre + 3 cartes, les mélanger
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
--Piège "Envoûtant" posable comme monstre (même méthode que Magical Hats officiel)
function s.trapfilter(c,tp)
	return c:IsTrap() and c:IsCode(table.unpack(s.pieges))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER|TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN)
end
function s.canhat(tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,s.jeton,nil,TYPES_TOKEN,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEDOWN_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 --3 nouvelles cartes posées dans tous les cas
			and s.canhat(tp)
			and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
--Le Piège devient un Monstre Normal 0/0 (comme dans le script officiel)
function s.settrap(tg,c)
	local e1=Effect.CreateEffect(tg)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	e1:SetReset(RESET_EVENT|RESET_TOGRAVE|RESET_REMOVE|RESET_TEMP_REMOVE|RESET_TOHAND|RESET_TODECK|RESET_OVERLAY)
	tg:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_RACE)
	e2:SetValue(RACE_ALL)
	tg:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e3:SetValue(0xff)
	tg:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(0)
	tg:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(0)
	tg:RegisterEffect(e5,true)
	tg:SetStatus(STATUS_NO_LEVEL,true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp)) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	--1) Poser le monstre ciblé
	local was_spellcaster=tc:IsRace(RACE_SPELLCASTER)
	if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
	tc:ClearEffectRelation()
	--2) Si c'était un Magicien : 1 Piège "Envoûtant" du Deck à la place d'un Jeton (au choix)
	local trap=nil
	if was_spellcaster then
		local tg=Duel.GetMatchingGroup(s.trapfilter,tp,LOCATION_DECK,0,nil,tp)
		if #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			trap=tg:Select(tp,0,1,nil):GetFirst()
		end
	end
	--3) Poser 3 cartes : 3 Jetons, ou 2 Jetons + le Piège
	local sg=Group.CreateGroup()
	for i=1,(trap and 2 or 3) do
		local token=Duel.CreateToken(tp,s.jeton)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
			sg:AddCard(token)
		end
	end
	if trap then
		s.settrap(trap,e:GetHandler())
		if Duel.SpecialSummonStep(trap,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE) then
			sg:AddCard(trap)
		end
	end
	Duel.SpecialSummonComplete()
	sg=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if #sg==0 then return end
	--4) Mélanger les cartes posées
	Duel.ConfirmCards(1-tp,sg)
	local all=sg:Clone()
	all:AddCard(tc)
	Duel.ShuffleSetCard(all)
	--5) Si le monstre posé quitte le terrain ou est retourné face recto : détruire les autres cartes posées
	sg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	e1:SetLabelObject(sg)
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
