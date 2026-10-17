--[VAACT] Cercle Envoûtant
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local CERCLE_ID = 910000062 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- 1) Activation de la carte (Piège Continu)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- 2) Effet : Ne peut pas attaquer
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

	-- 3) Effet : Ne peut pas changer de position de combat
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.postg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	
	-- 4) Effet : Perd 700 ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.atktg)
	e4:SetValue(-700)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	
	-- 5) Effet : Si la cible est détruite, détruire cette carte
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.checkop)
	c:RegisterEffect(e5)
	
	-- Lier la cible de l'activation à l'effet e5 pour savoir qui surveiller
	e1:SetLabelObject(e5)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- Sauvegarder la cible dans la carte Piège pour les effets continus
		c:SetCardTarget(tc)
		
		-- Activer la surveillance de destruction pour détruire le piège
		local e5=e:GetLabelObject() -- On récupère l'effet e5
		if e5 then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_DESTROY_REPLACE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetTarget(s.reptg)
			e6:SetOperation(s.repop)
			e6:SetLabelObject(tc)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e6)
		end
	end
end

function s.atktg(e,c)
	local tc=e:GetLabelObject():GetLabelObject():GetFirstCardTarget()
	return tc and c==tc
end

function s.postg(e,c)
	local tc=e:GetLabelObject():GetLabelObject():GetFirstCardTarget()
	return tc and c==tc
end

-- Vérifie si la carte quitte le terrain
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc then
		-- Si la cible a été détruite
		if tc:IsReason(REASON_DESTROY) then
			Duel.Destroy(c, REASON_EFFECT)
		end
	end
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return true
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- Ce code est une sécurité, géré par le checkop normalement
end