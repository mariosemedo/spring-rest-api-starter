package com.monogramm.starter.persistence.user.service;

import com.monogramm.starter.config.data.InitialDataLoader;
import com.monogramm.starter.config.security.IAuthenticationFacade;
import com.monogramm.starter.dto.user.RegistrationDto;
import com.monogramm.starter.dto.user.UserDto;
import com.monogramm.starter.persistence.AbstractGenericService;
import com.monogramm.starter.persistence.parameter.dao.ParameterRepository;
import com.monogramm.starter.persistence.parameter.entity.Parameter;
import com.monogramm.starter.persistence.parameter.exception.ParameterNotFoundException;
import com.monogramm.starter.persistence.role.dao.RoleRepository;
import com.monogramm.starter.persistence.role.entity.Role;
import com.monogramm.starter.persistence.role.exception.RoleNotFoundException;
import com.monogramm.starter.persistence.user.dao.UserRepository;
import com.monogramm.starter.persistence.user.entity.User;
import com.monogramm.starter.persistence.user.exception.UserNotFoundException;

import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * {@link User} service.
 * 
 * @author madmath03
 */
@Service
public class UserServiceImpl extends AbstractGenericService<User, UserDto> implements UserService {

  /**
   * Logger for {@link UserServiceImpl}.
   */
  private static final Logger LOG = LoggerFactory.getLogger(UserServiceImpl.class);

  public static final String DEFAULT_ROLE = InitialDataLoader.DEFAULT_ROLE;
  public static final String DEFAULT_ROLE_PARAMETER = InitialDataLoader.DEFAULT_ROLE_PARAMETER;

  private final RoleRepository roleRepository;

  private final ParameterRepository parameterRepository;

  /**
   * Create a {@link UserServiceImpl}.
   * 
   * @param userDao the user repository.
   * @param roleDao the role repository.
   * @param parameterDao the parameter repository.
   * @param authenticationFacade a facade to retrieve the authentication object.
   * 
   * @throws IllegalArgumentException if {@code roleDao} is {@code null}.
   */
  @Autowired
  public UserServiceImpl(final UserRepository userDao, final RoleRepository roleDao,
      ParameterRepository parameterDao, IAuthenticationFacade authenticationFacade) {
    super(userDao, userDao, new UserBridge(userDao, roleDao), authenticationFacade);
    if (roleDao == null) {
      throw new IllegalArgumentException("Role repository cannot be null.");
    }
    this.roleRepository = roleDao;
    if (parameterDao == null) {
      throw new IllegalArgumentException("Parameter repository cannot be null.");
    }
    this.parameterRepository = parameterDao;
  }

  /**
   * Get the {@link #roleRepository}.
   * 
   * @return the {@link #roleRepository}.
   */
  protected final RoleRepository getRoleRepository() {
    return roleRepository;
  }

  /**
   * Get the {@link #parameterRepository}.
   * 
   * @return the {@link #parameterRepository}.
   */
  protected final ParameterRepository getParameterRepository() {
    return parameterRepository;
  }

  @Override
  protected UserRepository getRepository() {
    return (UserRepository) super.getRepository();
  }

  @Override
  public UserBridge getBridge() {
    return (UserBridge) super.getBridge();
  }

  @Override
  protected boolean exists(User entity) {
    return getRepository().exists(entity.getId(), entity.getUsername(), entity.getEmail());
  }

  @Override
  protected UserNotFoundException createEntityNotFoundException(User entity) {
    return new UserNotFoundException("Following user not found:" + entity);
  }

  @Override
  protected UserNotFoundException createEntityNotFoundException(UUID entityId) {
    return new UserNotFoundException("No user for ID=" + entityId);
  }

  @Transactional(readOnly = true)
  @Override
  public List<User> findAllContainingUsername(final String username) {
    return getRepository().findAllContainingUsernameIgnoreCase(username);
  }

  @Transactional(readOnly = true)
  @Override
  public List<User> findAllContainingEmail(final String email) {
    return getRepository().findAllContainingEmailIgnoreCase(email);
  }

  @Transactional(readOnly = true)
  @Override
  public List<User> findAllContainingUsernameOrEmail(final String username, final String email) {
    return getRepository().findAllContainingUsernameOrEmailIgnoreCase(username, email);
  }

  @Transactional(readOnly = true)
  @Override
  public User findByUsername(String username) {
    return getRepository().findByUsernameIgnoreCase(username);
  }

  @Transactional(readOnly = true)
  @Override
  public User findByEmail(String email) {
    return getRepository().findByEmailIgnoreCase(email);
  }

  @Transactional(readOnly = true)
  @Override
  public User findByUsernameOrEmail(String username, String email) {
    User user;
    try {
      user = getRepository().findByUsernameOrEmailIgnoreCase(username, email);
    } catch (UserNotFoundException e) {
      LOG.debug("No user found for specified username and email", e);
      user = null;
    }
    return user;
  }

  @Override
  public User setPassword(final UUID userId, char[] password) {
    final User updatedEntity = getRepository().setPassword(userId, password);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public User setPasswordByOwner(UUID userId, char[] password, User owner) {
    final User updatedEntity = getRepository().setPasswordByOwner(userId, password, owner);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public User setEnabled(final UUID userId, boolean enabled) {
    final User updatedEntity = getRepository().setEnabled(userId, enabled);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public User setEnabledByOwner(UUID userId, boolean enabled, User owner) {
    final User updatedEntity = getRepository().setEnabledByOwner(userId, enabled, owner);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public User setVerified(final UUID userId, boolean verified) {
    final User updatedEntity = getRepository().setVerified(userId, true);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public User setVerifiedByOwner(UUID userId, boolean verified, User owner) {
    final User updatedEntity = getRepository().setVerifiedByOwner(userId, true, owner);

    if (updatedEntity == null) {
      throw this.createEntityNotFoundException(userId);
    }

    return updatedEntity;
  }

  @Override
  public boolean register(final RegistrationDto registration) {
    final User user = User.builder(registration.getUsername(), registration.getEmail())
        .password(registration.getPassword()).build();

    /*
     * TODO Add password strengths and rules.
     * http://www.baeldung.com/registration-password-strength-and-rules
     */

    Parameter defaultRoleParameter = null;
    try {
      defaultRoleParameter = parameterRepository.findByNameIgnoreCase(DEFAULT_ROLE_PARAMETER);
    } catch (ParameterNotFoundException e) {
      LOG.warn("Default role parameter not found. Using initial default role", e);
    }
    if (defaultRoleParameter == null) {
      defaultRoleParameter = Parameter.builder(DEFAULT_ROLE_PARAMETER, DEFAULT_ROLE).build();
    }

    final Role defaultRole;
    try {
      defaultRole = roleRepository.findByNameIgnoreCase(defaultRoleParameter.getValue());
    } catch (RoleNotFoundException e) {
      LOG.error("Default role not found", e);
      throw e;
    }
    user.setRole(defaultRole);

    return this.add(user);
  }
}
