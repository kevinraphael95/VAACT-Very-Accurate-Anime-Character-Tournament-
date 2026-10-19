--[VAACT] Dragon du Virus Maudit (Doom Virus Dragon)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=22804644
--Piège listé comme matériel pour "Le Croc de Critias" : "Virus Broyeur de Carte" (Crush Card Virus)
s.material_trap=57728570
--Les monstres de l'adversaire avec cet ATK ou MOINS sont détruits (texte VAACT : "1500 ATK ou moins")
s.seuil=1500

function s.initial_effect(c)
	c:EnableReviveLimit()
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Doit être Invoqué Spécialement avec "Le Croc de Critias"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--Tant que cette carte est face recto : détruire les monstres de l'adversaire de 1500 ATK ou moins
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsMonster() and c:GetAttack()<=s.seuil
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
